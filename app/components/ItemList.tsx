// @ts-nocheck
import * as React from "react";
import { View, FlatList, Text, StyleSheet, Pressable } from "react-native";
import hymnDetail from "../screens/hymns/hymnDetail";
import { useNavigation } from "@react-navigation/native";

const ItemList = ({ arr, color, onPress }) => {
  const navigation = useNavigation();
  return (
    <FlatList
      data={arr}
      renderItem={({ item, index }) => (
        <View style={Styles.container}>
          <View style={Styles.number(color)}>
            <Text key={`${index}-no`} style={Styles.text(color)}>
              {item.no}
            </Text>
          </View>
          <View style={Styles.title(color)}>
            <Pressable onPress={onPress}>
              <Text key={`${index}-title`} style={Styles.text(color)}>
                {item.title}
              </Text>
            </Pressable>
          </View>
        </View>
      )}
    />
  );
};

const Styles = StyleSheet.create({
  container: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "flex-start",
    width: "100%",
    marginBottom: 8,
  },
  number: (color) => ({
    backgroundColor: `${color}`,
    marginRight: 20,
    alignItems: "center",
    justifyContent: "center",
    width: "20%",
    padding: 12,
  }),
  title: (color) => ({
    width: "80%",
    paddingHorizontal: 20,
    paddingVertical: 20,
    whiteSpace: "nowrap",
    justifyContent: "center",
    backgroundColor: `${color}`,
  }),
  text: (color) => ({
    color: `#fff`,
    fontSize: 24,
  }),
});

export default ItemList;
