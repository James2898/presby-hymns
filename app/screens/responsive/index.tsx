import * as React from "react";
import { StyleSheet, Text, View } from "react-native";

export const ResponsiveReadingScreen = () => {
  return (
    <View style={Styles.container}>
      <Text style={Styles.header}>Responsive Reading</Text>
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

export default ResponsiveReadingScreen;
