import React from "react";
import { View, StyleSheet, Text, Pressable } from "react-native";

export const HomeScreen = ({ navigation }) => {
  return (
    <View style={Styles.container}>
      {/* Header */}
      <Text style={Styles.header}>Presbyterian Hymns</Text>
      {/* BUTTONS */}
      <View style={Styles.btnGroup}>
        {/* Hymns */}
        <Pressable
          style={Styles.btn}
          onPress={() => navigation.navigate("Hymns")}
        >
          <Text style={Styles.text}>Hymns</Text>
        </Pressable>

        {/* Responsive Reading */}
        <Pressable
          style={Styles.btn}
          onPress={() => navigation.navigate("ResponsiveReading")}
        >
          <Text style={Styles.text}>Responsive Reading</Text>
        </Pressable>

        {/* Catechism */}
        <Pressable
          style={Styles.btn}
          onPress={() => navigation.navigate("Catechisim")}
        >
          <Text style={Styles.text}>Catechism</Text>
        </Pressable>

        {/* Credits */}
        <Pressable
          style={Styles.btn}
          onPress={() => navigation.navigate("Credits")}
        >
          <Text style={Styles.text}>Credits</Text>
        </Pressable>
      </View>
    </View>
  );
};

const Styles = StyleSheet.create({
  header: {
    textAlign: "center",
    alignItems: "center",
    letterSpacing: 3,
    fontSize: 48,
    marginBottom: 128,
  },
  container: {
    paddingTop: 100,
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    width: "100%",
  },
  btnGroup: {
    display: "flex",
    width: "100%",
    padding: 0,
    gap: 24,
    alignItems: "flex-start",
  },
  btn: {
    alignItems: "flex-start",
    justifyContent: "center",
    paddingVertical: 12,
    paddingHorizontal: 32,
    width: 340,
    borderTopRightRadius: 8,
    borderBottomRightRadius: 8,
    elevation: 3,
    backgroundColor: "rgba(0, 0, 0, .8)",
  },
  text: {
    color: "#fff",
    fontSize: 24,
    lineHeight: 32,
    fontWeight: "bold",
    letterSpacing: 1,
  },
});

export default HomeScreen;
