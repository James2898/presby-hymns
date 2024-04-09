import React from "react";

import AppContainer from "./app/navigations/AppNavigation";
import { ImageBackground } from "react-native";
import { PaperProvider } from "react-native-paper";

const App = () => {
  const [locale, setLocale] = React.useState<"eng" | "tag">("eng");
  return (
    <PaperProvider>
      <AppContainer locale={locale} setLocale={setLocale} />
    </PaperProvider>
  );
};

export default App;
