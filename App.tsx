import * as React from "react";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { StatusBar } from "expo-status-bar";
import * as ImagePicker from "expo-image-picker";
import { StyleSheet, Text, View, Image } from "react-native";

import ImageViewer from "./app/components/ImageViewer";
import Button from "./app/components/Button";
import CircleButton from "./app/components/CirleButton";
import IconButton from "./app/components/IconButton";
import EmojiPicker from "./app/components/EmojiPicker";
import EmojiList from "./app/components/EmojiList";
import EmojiSticker from "./app/components/EmojiSticker";

const PlaceholderImage = {
  uri: "https://docs.expo.dev/static/images/tutorial/background-image.png",
};

const App = () => {
  const [pickedEmoji, setPickedEmoji] = React.useState(null);
  const [isModalVisible, setIsModalVisible] = React.useState(false);
  const [selectedImage, setSelectedImage] = React.useState(null);
  const [showApptions, setShowAppOptions] = React.useState(false);

  const onReset = () => {
    setShowAppOptions(false);
  };

  const onAddSticker = () => {
    setIsModalVisible(true);
  };

  const onModalClose = () => {
    setIsModalVisible(false);
  };

  const onSaveImageAsync = async () => {};

  const pickImageAsync = async () => {
    let result = await ImagePicker.launchImageLibraryAsync({
      allowsEditing: true,
      quality: 1,
    });

    if (!result.canceled) {
      setSelectedImage(result.assets[0].uri);
      setShowAppOptions(true);
    } else {
      setSelectedImage(null);
      alert("You did not select any image.");
    }
  };

  return (
    <GestureHandlerRootView style={Styles.container}>
      <View style={Styles.imageContainer}>
        <ImageViewer
          placeholderImage={PlaceholderImage}
          selectedImage={selectedImage}
        />
        {pickedEmoji && (
          <EmojiSticker imageSize={40} stickerSource={pickedEmoji} />
        )}
      </View>
      {showApptions ? (
        <View style={Styles.optionsContainer}>
          <View style={Styles.optionsRow}>
            <IconButton icon="refresh" label="Reset" onPress={onReset} />
            <CircleButton onPress={onAddSticker} />
            <IconButton
              icon="save-alt"
              label="Save"
              onPress={onSaveImageAsync}
            />
          </View>
        </View>
      ) : (
        <View style={Styles.footerContainer}>
          <Button
            theme="primary"
            label="Choose a photo"
            onPress={pickImageAsync}
          />
          <Button
            label="Use tihs photo"
            onPress={() => setShowAppOptions(true)}
          />
        </View>
      )}
      <EmojiPicker isVisible={isModalVisible} onClose={onModalClose}>
        <EmojiList onSelect={setPickedEmoji} onCloseModal={onModalClose} />
      </EmojiPicker>
      <StatusBar style="auto" />
    </GestureHandlerRootView>
  );
};

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
  optionsContainer: {
    position: "absolute",
    bottom: 80,
  },
  optionsRow: {
    alignItems: "center",
    flexDirection: "row",
  },
});

export default App;
