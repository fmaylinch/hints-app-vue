<template>
  <v-app>
    <v-app-bar app dark>
      <div class="d-flex align-center">
        <div>Hint Cards</div>
      </div>
    </v-app-bar>

    <v-content>
      <CardList />
    </v-content>
  </v-app>
</template>

<script>
import CardList from "@/components/CardList";

export default {
  name: "App",

  components: {
    CardList
  },

  data: () => ({
    //
  })
};
</script>
