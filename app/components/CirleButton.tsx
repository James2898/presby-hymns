import * as React from "react";
import { MaterialIcons } from "@expo/vector-icons";
import { Pressable, StyleSheet, View } from "react-native";

const CircleButton = ({ onPress }) => {
  return (
    <View style={Styles.circleButtonContainer}>
      <Pressable style={Styles.circleButton} onPress={onPress}>
        <MaterialIcons name="add" size={38} color="#25292e" />
      </Pressable>
    </View>
  );
};

const Styles = StyleSheet.create({
  circleButtonContainer: {
    width: 84,
    height: 84,
    marginHorizontal: 60,
    borderWidth: 4,
    borderColor: "#ffd33d",
    borderRadius: 42,
    padding: 3,
  },
  circleButton: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    borderRadius: 42,
    backgroundColor: "#fff",
  },
});

export default CircleButton;
