// @ts-nocheck
import {
  FontAwesome,
  FontAwesome5,
  MaterialCommunityIcons,
} from "@expo/vector-icons";
import * as React from "react";
import { StyleSheet, View, Text, Pressable } from "react-native";

const HymnToolbar = ({ color }) => {
  return (
    <View style={Styles.container}>
      <View style={Styles.linkButtons}>
        <FontAwesome5 name="youtube" size={32} />
        <MaterialCommunityIcons name="music" size={32} />
      </View>
      <View style={Styles.fontButtons}>
        <Pressable onPress={() => alert("Increase Font")}>
          <FontAwesome name="plus" size={24} color={color} />
        </Pressable>
        <Text style={Styles.fontSize}>Aa</Text>
        <Pressable onPress={() => alert("Decrease Font")}>
          <FontAwesome name="minus" size={24} color={color} />
        </Pressable>
      </View>
    </View>
  );
};

const Styles = StyleSheet.create({
  linkButtons: {
    display: "flex",
    flexDirection: "row",
    gap: 4,
  },
  fontButtons: {
    display: "flex",
    flexDirection: "row",
    gap: 7,
    alignItems: "center",
    paddingHorizontal: 8,
  },
  fontIcons: (color) => ({
    color: color,
  }),
  fontSize: {
    fontSize: 32,
    fontWeight: "bold",
  },
  container: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    padding: 4,
  },
});

export default HymnToolbar;
