import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { TextInput } from "react-native-paper";

import Search from "../../components/Search";
import RadioButton from "../../components/RadioButton";
import ItemList from "../../components/ItemList";
import { hymnEng, hymnTag } from "../../../const/hymns";

export const HymnsScreen = ({ locale, setLocale }) => {
  const color = locale === "eng" ? "#6481E5" : "#A72828";

  return (
    <View style={Styles.container}>
      <Search color={color} />
      <RadioButton color={color} status={locale} onPress={setLocale} />
      <ItemList arr={locale === "eng" ? hymnEng : hymnTag} color={color} />
    </View>
  );
};

const Styles = StyleSheet.create({
  header: {
    textAlign: "center",
    alignItems: "center",
    backgroundColor: "#fff3de",
  },
  container: {
    flex: 1,
  },
});

export default HymnsScreen;
