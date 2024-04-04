import React from "react";
import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View, Image } from "react-native";

import ImageViewer from "./app/components/ImageViewer";
import Button from "./app/components/Button";

const PlaceholderImage = {
  uri: "https://docs.expo.dev/static/images/tutorial/background-image.png",
};

export default function App() {
  return (
    <View style={Styles.container}>
      <View style={Styles.imageContainer}>
        <ImageViewer imageSource={PlaceholderImage} />
      </View>
      <View style={Styles.footerContainer}>
        <Button theme="primary" label="Choose a photo" />
        <Button label="Use tihs photo" />
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

const Styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#25292e",
    alignItems: "center",
    justifyContent: "center",
  },
  imageContainer: {
    flex: 1,
    paddingTop: 58,
  },
  image: {
    width: 320,
    height: 440,
    borderRadius: 18,
  },
  footerContainer: {
    flex: 1 / 3,
    alignItems: "center",
  },
});
