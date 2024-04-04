import * as React from "react";
import { FlatList, Platform, Pressable, StyleSheet, Image } from "react-native";

const EmojiList = ({ onSelect, onCloseModal }) => {
  const [emoji] = React.useState([
    require("../../assets/images/emoji1.png"),
    require("../../assets/images/emoji2.png"),
    require("../../assets/images/emoji3.png"),
    require("../../assets/images/emoji4.png"),
    require("../../assets/images/emoji5.png"),
  ]);

  return (
    <FlatList
      horizontal
      showsHorizontalScrollIndicator={Platform.OS === "web"}
      data={emoji}
      contentContainerStyle={Styles.listContainer}
      renderItem={({ item, index }) => (
        <Pressable
          onPress={() => {
            onSelect(item);
            onCloseModal();
          }}
        >
          <Image source={item} key={index} style={Styles.image} />
        </Pressable>
      )}
    />
  );
};

const Styles = StyleSheet.create({
  listContainer: {
    borderTopRightRadius: 10,
    borderTopLeftRadius: 10,
    paddingHorizontal: 20,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  image: {
    width: 100,
    height: 100,
    marginRight: 20,
  },
});

export default EmojiList;
