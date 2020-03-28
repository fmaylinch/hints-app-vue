<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>All Cards</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon><v-icon>mdi-magnify</v-icon></v-btn>
      <v-btn icon><v-icon>mdi-plus</v-icon></v-btn>
      <v-btn icon><v-icon>mdi-delete</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-list>
          <v-list-item
            v-for="card in cards"
            :key="card.id"
            @click="openCard(card)"
          >
            <v-list-item-content>
              <v-list-item-title class="card-title">
                <span>{{ card.hints[0] }}</span>
                <span>{{ card.hints[1] }}</span>
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-card>
    </v-content>
  </div>
</template>

<script>
import axios from "axios";
import constants from "@/constants.js";

export default {
  name: "CardList",
  data: () => ({
    cards: []
  }),
  created() {
    axios
      .post(constants.apiUrl + "/cards/getAll")
      .then(resp => (this.cards = resp.data))
      .catch(e => console.error("API Error", e));
  },
  methods: {
    openCard: function(card) {
      console.log("Open card", card);
    }
  }
};
</script>

<style scoped>
.card-title {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
}
</style>
