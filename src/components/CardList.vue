<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>
        Hint Cards
        <span class="title-info">{{titleInfo()}}</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="createCard()"><v-icon>mdi-plus</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-container>
          <v-text-field
            clearable
            v-model="search"
            placeholder="Search…"
          />
        </v-container>
        <v-list>
          <v-list-item
            v-for="card in searchedCards"
            :key="card.id"
            @click="editCard(card)"
          >
            <v-list-item-content>
              <v-list-item-title class="card-title">
                <span>{{ card.hints[0] }}</span>
                <span>{{ card.hints[1] }}</span>
              </v-list-item-title>
              <v-progress-linear
                height="1"
                :color="colorForCard(card)"
                :value="card.score">
              </v-progress-linear>
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
import { EventBus } from '@/event-bus.js';
import CardUpdateAction from '@/card-update-action.js';
import Util from "@/util.js";

export default {
  name: "CardList",
  data: () => ({
    search: null,
    cards: []
  }),
  computed: {
    searchedCards: function() {
      const lowerSearch = this.search ? this.search.toLowerCase() : "";
      return this.cards.filter(it => it.rawContent.indexOf(lowerSearch) >= 0);
    }
  },
  methods: {
    retrieveCardsFromApi: function() {
      console.log("Loading cards from API");
      axios
        .post(constants.apiUrl + "/cards/getAll")
        .then(resp => this.prepareCards(resp.data))
        .catch(e => console.error("API Error", e));
    },
    prepareCards: function(cards) {
      console.log("Preparing cards");
      this.fillRawContent(cards);
      this.cards = cards;
    },
    /** Fills each card.rawContent with lowercase content of all fields, useful for searching */
    fillRawContent(cards) {
      for (let card of cards) {
        card.rawContent = Util.getCardRawContent(card).toLowerCase();
      }
    },
    titleInfo: function() {
      return this.search
        ? this.searchedCards.length + " of " + this.cards.length
        : this.cards.length;
    },
    colorForCard: function(card) {
      return Util.colorFromScore(card.score);
    },
    createCard: function() {
      this.editCard(null);
    },
    editCard: function(card) {
      // The name of the route is defined in "src/router/index.js".
      // The route definition there doesn't have params like :id, so we're
      // actually passing an object directly. As you can read in
      // https://forum.vuejs.org/t/passing-objects-to-vue-router/32070
      // when the page is reloaded it won't contain the `card`.
      this.$router.push({ name: "EditCard", params: { card: card } });
    }
  },
  created() {
    this.retrieveCardsFromApi();

    // Remove listener. When developing the listeners are accumulated when vue refreshes.
    EventBus.$off("card-updated");
    EventBus.$on("card-updated", update => {
      console.log("Card updated", update);
      if (update.action === CardUpdateAction.update) {
        console.log("Updating card");
        axios
          .post(constants.apiUrl + "/cards/saveOrUpdate", update.card)
          .then(() => this.retrieveCardsFromApi())
          .catch(e => console.error("API Error", e));
      }
    });
  }
};
</script>

<style scoped>
.title-info {
  font-size: 0.9rem;
  color: grey;
  padding-left: 8px;
}
.card-title {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
  color: darkgrey;
}
</style>
