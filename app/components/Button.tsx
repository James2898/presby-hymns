import React from "react";
import { Pressable, StyleSheet, Text, View } from "react-native";
import { FontAwesome } from "@expo/vector-icons";

type props = {
  label: string;
  theme?: "primary";
};

const Button = ({ label, theme }: props) => {
  if (theme === "primary") {
    return (
      <View
        style={[
          Styles.buttonContainer,
          { borderWidth: 4, borderColor: "#ffd33d", borderRadius: 18 },
        ]}
      >
        <Pressable
          style={[Styles.button, { backgroundColor: "#fff" }]}
          onPress={() => alert("You pressed a button")}
        >
          <FontAwesome
            name="picture-o"
            size={18}
            color="#25292e"
            style={Styles.buttonIcon}
          />
          <Text style={[Styles.buttonLabel, { color: "25292e" }]}>{label}</Text>
        </Pressable>
      </View>
    );
  }
  return (
    <View style={Styles.buttonContainer}>
      <Pressable style={Styles.button} onPress={() => alert("Hit")}>
        <Text style={Styles.buttonLabel}>
          {theme}
          {label}
        </Text>
      </Pressable>
    </View>
  );
};

const Styles = StyleSheet.create({
  buttonContainer: {
    width: 320,
    height: 68,
    marginHorizontal: 20,
    // backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
    padding: 3,
  },
  button: {
    borderRadius: 10,
    width: "100%",
    height: "100%",
    alignItems: "center",
    justifyContent: "center",
    flexDirection: "row",
  },
  buttonIcon: {
    paddingRight: 8,
  },
  buttonLabel: {
    // color: "red",
    color: "#fff",
    fontSize: 16,
  },
});

export default Button;
