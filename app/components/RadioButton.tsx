// @ts-nocheck
import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { RadioButton as RadioBtn } from "react-native-paper";

const RadioButton = ({ color, status, onPress, size }) => {
  return (
    <View style={Styles.radioButtonGroup}>
      <RadioBtn
        value="first"
        color={color}
        style={Styles.radioBtn}
        status={status === "eng" ? "checked" : "unchecked"}
        onPress={() => {
          onPress("eng");
        }}
      />
      <Text style={Styles.text({ color, size })}>English</Text>
      <RadioBtn
        value="second"
        color={color}
        style={Styles.radioBtn}
        status={status === "tag" ? "checked" : "unchecked"}
        onPress={() => {
          onPress("tag");
        }}
      />
      <Text style={Styles.text({ color, size })}>Filipino</Text>
    </View>
  );
};

const Styles = StyleSheet.create({
  radioButtonGroup: {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
  },
  text: ({ color, size }) => ({
    color: `${color}`,
    fontSize: size,
  }),
});

export default RadioButton;
