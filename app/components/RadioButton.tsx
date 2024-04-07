// @ts-nocheck
import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { RadioButton as RadioBtn } from "react-native-paper";

const RadioButton = ({ color }) => {
  const [checked, setChecked] = React.useState<"first" | "second">("first");
  return (
    <View style={Styles.radioButtonGroup(color)}>
      <RadioBtn
        value="first"
        color={color}
        style={Styles.radioBtn}
        status={checked === "first" ? "checked" : "unchecked"}
        onPress={() => {
          setChecked("first");
        }}
      />
      <Text style={Styles.text(color)}>English</Text>
      <RadioBtn
        value="second"
        color={color}
        style={Styles.radioBtn}
        status={checked === "second" ? "checked" : "unchecked"}
        onPress={() => {
          setChecked("second");
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
