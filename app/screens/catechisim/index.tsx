import * as React from "react";
import { StyleSheet, Text, View } from "react-native";

export const CatechisimScreen = () => {
  return (
    <View style={Styles.container}>
      <Text style={Styles.header}>Catechisim Screen</Text>
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
    alignItems: "center",
    justifyContent: "center",
  },
});

export default CatechisimScreen;
