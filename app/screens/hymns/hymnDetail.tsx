// @ts-nocheck
import { useNavigation } from "@react-navigation/native";
import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { MaterialIcons } from "@expo/vector-icons";

import RadioButton from "../../components/RadioButton";
import HymnToolbar from "../../components/HymnToolbar";

export const HymnDetail = ({ route }) => {
  // TODO: RECREATE TO REDUX
  const {
    color: _color,
    locale: _locale,
    setLocale: _setLocale,
  } = route.params;

  const [locale, setLocale] = React.useState(_locale);
  const color = React.useMemo(() => {
    return locale === "eng" ? "#6481E5" : "#A72828";
  }, [locale]);

  const navigation = useNavigation();

  const handleLocalChange = (e) => {
    setLocale(e);
    _setLocale(e);
  };

  React.useEffect(() => {
    navigation.setOptions({
      title: (
        <View style={Styles.headerContainer}>
          <RadioButton
            color={"#fff"}
            status={locale}
            size={16}
            onPress={handleLocalChange}
          />
          <View style={Styles.navigationBtnGroup}>
            <MaterialIcons name="navigate-before" size={32} color="#fff" />
            <MaterialIcons name="navigate-next" size={32} color="#fff" />
          </View>
        </View>
      ),
      headerStyle: {
        elevation: 0,
        shadowOpacity: 0,
        backgroundColor: color,
      },
    });
  }, [color, locale, setLocale]);

  return (
    // @ts-ignore
    <View style={Styles.bodyContainer(color)}>
      <HymnToolbar color={color} />
    </View>
  );
};

const Styles = StyleSheet.create({
  headerContainer: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-around",
    gap: 36,
    width: "100%",
  },
  navigationBtnGroup: {
    marginLeft: 10,
    gap: 8,
    width: "100%",
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
  },
  bodyContainer: (color) => ({
    borderWidth: 8,
    height: "100%",
    borderColor: color,
  }),
});

export default HymnDetail;
