import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { TextInput } from "react-native-paper";

import Search from "../../components/Search";
import RadioButton from "../../components/RadioButton";

export const HymnsScreen = () => {
  const [local, setLocale] = React.useState<"eng" | "tag">("eng");

  return (
    <View style={Styles.container}>
      <Search color={"#6481E5"} />
      <RadioButton color={"#6481E5"} />
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
