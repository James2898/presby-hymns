import * as React from "react";
import { Text, View } from "react-native";

export const HymnDetail = ({ route }) => {
  const { color } = route.params;
  return (
    <View>
      <Text>{color}</Text>
    </View>
  );
};

export default HymnDetail;
