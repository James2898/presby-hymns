import React from "react";

import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import { ImageBackground, StyleSheet } from "react-native";

import { HomeScreen } from "../screens/home";
import { HymnsScreen } from "../screens/hymns";
import { ResponsiveReadingScreen } from "../screens/responsive";
import { CatechisimScreen } from "../screens/catechisim";
import { CreditsScreen } from "../screens/credits";

const options = {
  hymns: {
    headerStyle: {
      backgroundColor: "#6481E5",
    },
    headerTintColor: "#fff",
  },
  responsiveReading: {
    title: "Responsive Reading",
    headerStyle: {
      backgroundColor: "#EF5C2E",
    },
    headerTintColor: "#fff",
  },
  catechisim: {
    title: "Shorter Catechism",
    headerStyle: {
      backgroundColor: "#235B09",
    },
    headerTintColor: "#fff",
  },
  credits: {
    headerStyle: {
      backgroundColor: "#6481E5",
    },
    headerTintColor: "#fff",
  },
};

const Stack = createStackNavigator();
const MainNavigator = () => {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="Home"
        component={HomeScreen}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="Hymns"
        component={HymnsScreen}
        options={options.hymns}
      />
      <Stack.Screen
        name="ResponsiveReading"
        component={ResponsiveReadingScreen}
        options={options.responsiveReading}
      />
      <Stack.Screen
        name="Catechisim"
        component={CatechisimScreen}
        options={options.catechisim}
      />
      <Stack.Screen
        name="Credits"
        component={CreditsScreen}
        options={options.credits}
      />
    </Stack.Navigator>
  );
};

const image = require("../../assets/images/church-picture.png");

const AppContainer = () => {
  return (
    <NavigationContainer>
      <MainNavigator />
    </NavigationContainer>
  );
};

const Styles = StyleSheet.create({
  bgImage: {
    flex: 1,
    resizeMode: "cover",
    justifyContent: "center",
  },
});

export default AppContainer;
