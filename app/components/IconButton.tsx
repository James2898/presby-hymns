import { MaterialIcons } from "@expo/vector-icons";
import * as React from "react";
import { Pressable, StyleSheet, Text } from "react-native";

const IconButton = ({ icon, label, onPress }) => {
  return (
    <Pressable style={Styles.iconButton} onPress={onPress}>
      <MaterialIcons name={icon} size={24} color="#fff" />
      <Text style={Styles.iconButtonLabel}>{label}</Text>
    </Pressable>
  );
};

const Styles = StyleSheet.create({
  iconButton: {
    justifyContent: "center",
    alignItems: "center",
  },
  iconButtonLabel: {
    color: "#fff",
    marginTop: 12,
  },
});

export default IconButton;
