import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { TextInput } from "react-native-paper";

import Search from "../../components/Search";
import RadioButton from "../../components/RadioButton";
import ItemList from "../../components/ItemList";
import { hymnEng } from "../../../const/hymns";

export const HymnsScreen = () => {
  const [local, setLocale] = React.useState<"eng" | "tag">("eng");
  const color = "#6481E5";

  return (
    <View style={Styles.container}>
      <Search color={color} />
      <RadioButton color={color} />
      <ItemList arr={hymnEng} color={color} />
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
