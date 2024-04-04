import * as React from "react";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import { View } from "react-native";
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withSpring,
} from "react-native-reanimated";

const EmojiSticker = ({ imageSize, stickerSource }) => {
  const scaleImage = useSharedValue(imageSize);
  const doubleTap = Gesture.Tap()
    .numberOfTaps(2)
    .onStart(() => {
      if (scaleImage.value == imageSize * 2) {
        scaleImage.value = scaleImage.value / 2;
      } else {
        scaleImage.value = scaleImage.value * 2;
      }
    });

  const imageStyle = useAnimatedStyle(() => {
    return {
      height: withSpring(scaleImage.value),
      width: withSpring(scaleImage.value),
    };
  });

  return (
    <View style={{ top: -350 }}>
      <GestureDetector gesture={doubleTap}>
        <Animated.Image
          source={stickerSource}
          resizeMode="contain"
          style={[imageStyle, { width: imageSize, height: imageSize }]}
        />
      </GestureDetector>
    </View>
  );
};

export default EmojiSticker;
