import os
import re
import sys

def parse_markdown_hymns(filepath, lang_code):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by ## headers
    # Matches: ## \#01 \- Title or ## #1 - Title or ## 01 - Title
    pattern = re.compile(r'^##\s*(?:\\#|#)?(\d+)\s*(?:\\-|[-–—:])\s*(.+)$', re.M)
    
    matches = list(pattern.finditer(content))
    hymns = []
    
    for i, match in enumerate(matches):
        num = int(match.group(1))
        raw_title = match.group(2).strip().replace('\\!', '!').replace('\\', '')
        start_idx = match.end()
        end_idx = matches[i + 1].start() if i + 1 < len(matches) else len(content)
        body = content[start_idx:end_idx].strip()
        hymns.append({
            'number': num,
            'title': raw_title,
            'body': body,
            'lang': lang_code
        })
    return hymns

# Standard Presbyterian hymn concert keys for top hymns (where known from hymnal)
DEFAULT_KEYS = {
    1: 'G',    # Doxology (OLD HUNDREDTH) usually in G
    2: 'C',    # Gloria Patri
    3: 'D',    # Hear Our Prayer, O Lord
    4: 'G',    # To God Be the Glory
    5: 'Eb',   # Holy, Holy, Holy (NICAEA)
    6: 'F',    # Praise to the Lord, the Almighty
    7: 'D',    # Crown Him with Many Crowns
    8: 'D',    # Come, Thou Fount of Every Blessing (NETTLETON)
    9: 'Ab',   # Come, Christians, Join to Sing
    10: 'Ab',  # O Worship the King (LYONS)
}

def clean_body_to_chordpro(body, default_key='C'):
    lines = body.splitlines()
    cho_lines = []
    in_verse = False
    in_chorus = False
    verse_num = 1
    has_chords = False

    # Regex to detect chord-only lines: e.g. "// G" or "G   D" or "// C D Em"
    chord_line_re = re.compile(r'^\s*(?://\s*)?([A-G][b#]?(?:m|maj|min|dim|aug|sus|add|\d)*(?:/[A-G][b#]?)?\s*)+$')
    verse_tag_re = re.compile(r'^\\?#\\?#\s*\(?Verse\s*(\d+)\)?', re.I)
    chorus_tag_re = re.compile(r'^\\?#\\?#\s*\(?Chorus\)?', re.I)
    
    i = 0
    while i < len(lines):
        raw_line = lines[i]
        line = raw_line.strip().replace('\\!', '!').replace('\\', '')

        # Skip empty lines if not inside section
        if not line:
            i += 1
            continue

        # Check section headers
        v_match = verse_tag_re.match(line)
        c_match = chorus_tag_re.match(line)

        if v_match:
            if in_verse:
                cho_lines.append("{end_of_verse}\n")
            if in_chorus:
                cho_lines.append("{end_of_chorus}\n")
                in_chorus = False
            verse_num = int(v_match.group(1))
            cho_lines.append(f"{{start_of_verse: {verse_num}}}")
            in_verse = True
            i += 1
            continue
        elif c_match:
            if in_verse:
                cho_lines.append("{end_of_verse}\n")
                in_verse = False
            if in_chorus:
                cho_lines.append("{end_of_chorus}\n")
            cho_lines.append("{start_of_chorus}")
            in_chorus = True
            i += 1
            continue

        # If we see a chord line followed by a lyric line
        if chord_line_re.match(line):
            has_chords = True
            # Clean chord tokens
            clean_chords = re.sub(r'//', '', line).strip()
            # If next line is text, we can associate chords, or place them inline
            if i + 1 < len(lines) and lines[i+1].strip() and not chord_line_re.match(lines[i+1].strip()):
                next_lyric = lines[i+1].strip().replace('\\!', '!').replace('\\', '')
                # If not inside a verse/chorus yet, open verse 1
                if not in_verse and not in_chorus:
                    cho_lines.append(f"{{start_of_verse: {verse_num}}}")
                    in_verse = True
                
                # Combine chord tokens over lyric
                # Format: [Chord]Lyric line
                chord_tokens = clean_chords.split()
                if chord_tokens:
                    cho_lines.append(f"[{']['.join(chord_tokens)}] {next_lyric}")
                else:
                    cho_lines.append(next_lyric)
                i += 2
                continue
            else:
                # Standalone chord line (e.g. Amen)
                if not in_verse and not in_chorus:
                    cho_lines.append(f"{{start_of_verse: {verse_num}}}")
                    in_verse = True
                chord_tokens = clean_chords.split()
                cho_lines.append(f"[{']['.join(chord_tokens)}]")
                i += 1
                continue

        # Plain lyric line
        if not in_verse and not in_chorus:
            cho_lines.append(f"{{start_of_verse: {verse_num}}}")
            in_verse = True

        cho_lines.append(line)
        i += 1

    if in_verse:
        cho_lines.append("{end_of_verse}")
    if in_chorus:
        cho_lines.append("{end_of_chorus}")

    return "\n".join(cho_lines), has_chords

def main():
    en_hymns = parse_markdown_hymns('raw_content/English Hymns.md', 'EN')
    tl_hymns = parse_markdown_hymns('raw_content/Tagalog Hymns.md', 'TL')

    os.makedirs('content/en', exist_ok=True)
    os.makedirs('content/tl', exist_ok=True)

    print(f"Parsed {len(en_hymns)} English hymns, {len(tl_hymns)} Tagalog hymns.")

    # Process English
    for h in en_hymns:
        num = h['number']
        key = DEFAULT_KEYS.get(num, 'C')
        body_cho, has_chords = clean_body_to_chordpro(h['body'], key)
        
        filepath = f"content/en/{num:03d}.cho"
        with open(filepath, 'w', encoding='utf-8') as out:
            out.write(f"{{number: {num}}}\n")
            out.write(f"{{title: {h['title']}}}\n")
            out.write(f"{{key: {key}}}\n\n")
            out.write(body_cho)
            out.write("\n")

    # Process Tagalog
    for h in tl_hymns:
        num = h['number']
        key = DEFAULT_KEYS.get(num, 'C')
        body_cho, has_chords = clean_body_to_chordpro(h['body'], key)
        
        filepath = f"content/tl/{num:03d}.cho"
        with open(filepath, 'w', encoding='utf-8') as out:
            out.write(f"{{number: {num}}}\n")
            out.write(f"{{title: {h['title']}}}\n")
            out.write(f"{{key: {key}}}\n\n")
            out.write(body_cho)
            out.write("\n")

    print(f"Generated {len(en_hymns)} files in content/en/ and {len(tl_hymns)} files in content/tl/.")

if __name__ == '__main__':
    main()
