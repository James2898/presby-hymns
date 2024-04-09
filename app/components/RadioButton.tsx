// @ts-nocheck
import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { RadioButton as RadioBtn } from "react-native-paper";

const RadioButton = ({ color, status, onPress }) => {
  return (
    <View style={Styles.radioButtonGroup(color)}>
      <RadioBtn
        value="first"
        color={color}
        style={Styles.radioBtn}
        status={status === "eng" ? "checked" : "unchecked"}
        onPress={() => {
          onPress("eng");
        }}
      />
      <Text style={Styles.text(color)}>English</Text>
      <RadioBtn
        value="second"
        color={color}
        style={Styles.radioBtn}
        status={status === "tag" ? "checked" : "unchecked"}
        onPress={() => {
          onPress("tag");
        }}
      />
      <Text style={Styles.text(color)}>Filipino</Text>
    </View>
  );
};

const Styles = StyleSheet.create({
  radioButtonGroup: (color: any) => ({
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
  }),
  radioBtn: (color: any) => ({
    fontSize: 32,
  }),
  text: (color: any) => ({
    color: `${color}`,
    fontSize: 23,
  }),
});

export default RadioButton;
