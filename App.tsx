import React from "react";

import AppContainer from "./app/navigations/AppNavigation";
import { ImageBackground } from "react-native";
import { PaperProvider } from "react-native-paper";

const App = () => {
  return (
    <PaperProvider>
      <AppContainer />
    </PaperProvider>
  );
};

export default App;
