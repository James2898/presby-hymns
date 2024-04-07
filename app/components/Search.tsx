// @ts-nocheck
import * as React from "react";
import { StyleSheet, View } from "react-native";
import { TextInput } from "react-native-paper";

const Search = ({ color }) => {
  return (
    <View style={Styles.container}>
      <TextInput
        style={Styles.input(color)}
        left={<TextInput.Icon icon="magnify" size={42} color={color} />}
      />
    </View>
  );
};

const Styles = StyleSheet.create({
  container: {
    display: "flex",
    marginHorizontal: 3,
    marginVertical: 6,
    width: "100%",
  },
  buttonIcon: {},
  icon: (color: any) => ({
    color: `${color}`,
  }),
  input: (color: any) => ({
    borderWidth: 1,
    fontSize: 20,
    backgroundColor: "#fff",
    borderColor: `${color}`,
    borderBottomColor: `${color}`,
  }),
});

export default Search;
