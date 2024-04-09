import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import { TextInput } from "react-native-paper";

import Search from "../../components/Search";
import RadioButton from "../../components/RadioButton";
import ItemList from "../../components/ItemList";
import { hymnEng, hymnTag } from "../../../const/hymns";
import { useNavigation } from "@react-navigation/native";

export const HymnsScreen = ({}) => {
  const navigation = useNavigation();

  const [locale, setLocale] = React.useState("eng");
  const color = React.useMemo(() => {
    return locale === "eng" ? "#6481E5" : "#A72828";
  }, [locale]);

  React.useEffect(() => {
    navigation.setOptions({
      headerStyle: {
        backgroundColor: color,
      },
    });
  }, [locale]);

  const handleItemClick = () =>
    // @ts-ignore
    navigation.navigate("HymnDetail", {
      color: color,
      locale: locale,
      setLocale: setLocale,
    });

  return (
    <View style={Styles.container}>
      <Search color={color} />
      <RadioButton
        color={color}
        status={locale}
        onPress={setLocale}
        size={23}
      />
      {locale === "eng" ? (
        <ItemList arr={hymnEng} color={color} onPress={handleItemClick} />
      ) : (
        <ItemList arr={hymnTag} color={color} onPress={handleItemClick} />
      )}
    </View>
  );
};

const Styles = StyleSheet.create({
  header: {
    textAlign: "center",
    alignItems: "center",
    backgroundColor: "#fff3de",
  },
  container: {
    flex: 1,
  },
});

export default HymnsScreen;
