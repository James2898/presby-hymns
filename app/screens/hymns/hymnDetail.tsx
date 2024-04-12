// @ts-nocheck
import * as React from "react";

import { useNavigation } from "@react-navigation/native";
import { Pressable, StyleSheet, Text, View } from "react-native";
import * as FileSystem from "expo-file-system";
import { MaterialIcons } from "@expo/vector-icons";

import { Asset } from "expo-asset";
const { localuri } = await Asset.fromModule(
  require("src/data/hymnEng/1.txt")
).downloadAsync();

import RadioButton from "../../components/RadioButton";
import HymnToolbar from "../../components/HymnToolbar";
import { hymnEng, hymnTag } from "../../../const/hymns";

export const HymnDetail = ({ route }) => {
  // TODO: RECREATE TO REDUX
  const {
    no: _hymnNo,
    color: _color,
    locale: _locale,
    setLocale: _setLocale,
  } = route.params;

  const [hymnNo, setHymnNo] = React.useState(_hymnNo);
  const [locale, setLocale] = React.useState(_locale);
  // const [fontSize, setFontSize] = React.useState(24)
  const navigation = useNavigation();

  const color = React.useMemo(() => {
    return locale === "eng" ? "#6481E5" : "#A72828";
  }, [locale]);

  const hymns = React.useMemo(() => {
    if (locale === "eng") {
      return hymnEng;
    } else {
      return hymnTag;
    }
  }, [hymnEng, hymnTag, locale]);

  const hymn = React.useMemo(() => {
    return hymns[hymnNo - 1];
  }, [hymnNo, hymns, locale]);

  // DISPLAY LOGICS
  const hideBeforeBtn = React.useMemo(() => {
    return hymnNo === 1;
  }, [hymnNo]);
  const hideNextBtn = React.useMemo(() => {
    return hymnNo === hymns.length;
  });
  const showLocaleBtn = React.useMemo(() => {
    return hymnTag[hymnNo - 1] && hymnEng[hymnNo - 1];
  }, [hymnTag, hymnEng, hymnNo]);

  const handleLocalChange = (e) => {
    setLocale(e);
    _setLocale(e);
  };

  const getHymn = async (hymnNo) => {
    try {
      const txt = await FileSystem.readAsStringAsync(localuri);
      if (txt) {
        console.log("has text");
      } else {
        alert("no Text");
      }
    } catch (e) {
      console.error("Couldn't read from file:", localuri, e);
    }
  };

  React.useEffect(() => {
    getHymn();
  }, []);

  React.useEffect(() => {
    navigation.setOptions({
      title: (
        <View style={Styles.headerContainer}>
          <View style={!showLocaleBtn && { opacity: 0 }}>
            <RadioButton
              color={"#fff"}
              status={locale}
              size={16}
              onPress={handleLocalChange}
            />
          </View>
          <View style={Styles.navigationBtnGroup}>
            {/* BEFORE BTN */}
            <Pressable
              onPress={() => setHymnNo(hymnNo - 1)}
              style={
                hideBeforeBtn && {
                  opacity: 0,
                }
              }
              disabled={hymnNo === 1}
            >
              <MaterialIcons name="navigate-before" size={32} color="#fff" />
            </Pressable>
            {/* NEXT BTN */}
            <Pressable
              onPress={() => {
                setHymnNo(hymnNo + 1);
              }}
              style={
                hideNextBtn && {
                  opacity: 0,
                }
              }
              disabled={hideNextBtn}
            >
              <MaterialIcons name="navigate-next" size={32} color="#fff" />
            </Pressable>
          </View>
        </View>
      ),
      headerStyle: {
        elevation: 0,
        shadowOpacity: 0,
        backgroundColor: color,
      },
    });
  }, [hymnNo, color, locale, hideBeforeBtn, hideNextBtn]);

  return (
    // @ts-ignore
    <View style={Styles.bodyContainer(color)}>
      <HymnToolbar color={color} />
      <View style={Styles.hymnContainer}>
        <View style={Styles.titleContainer}>
          <Text style={Styles.titleNo}>{hymnNo}</Text>
          <Text style={Styles.titleText}>{hymn.title}</Text>
        </View>
      </View>
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
  hymnContainer: {},
  titleContainer: {
    alignItems: "center",
  },
  titleNo: {
    fontSize: 36,
    fontWeight: "bold",
  },
  titleText: {
    fontSize: 28,
    textDecorationLine: "underline",
    textAlign: "center",
    marginHorizontal: 18,
  },
  bodyContainer: (color) => ({
    borderWidth: 8,
    height: "100%",
    borderColor: color,
  }),
});

export default HymnDetail;
