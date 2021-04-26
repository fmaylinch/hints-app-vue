<template>
  <div>
    <v-app-bar app dark>
      <v-toolbar-title>{{ title }}</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn v-if="isEditing" @click="deleteCard()" icon><v-icon>mdi-delete</v-icon></v-btn>
    </v-app-bar>
    <v-content>
      <v-card flat tile>
        <v-container>
          <v-textarea v-model="cardForm.hints" label="Hints" auto-grow rows="1" />
          <v-textarea v-model="cardForm.notes" label="Notes" auto-grow rows="1" />
          <v-slider :color="sliderColor" v-model="cardForm.score" min="0" max="100" />
          <v-text-field v-model="cardForm.tags" label="Tags" auto-grow rows="1" />
        </v-container>
      </v-card>
    </v-content>
  </div>
</template>

<script>
import {EventBus} from '@/event-bus.js';
import CardUpdateAction from '@/card-update-action.js';
import Util from "@/util.js";

export default {
  props: {
    card: Object // route params that comes as props thanks to configuration in routes
  },
  data: () => ({
    cardForm: null
  }),
  computed: {
    sliderColor() {
      return Util.colorFromScore(this.cardForm.score);
    },
    isEditing() {
      return this.card != null;
    },
    title() {
      return this.isEditing ? "Edit Card" : "Create Card";
    }
  },
  created() {
    // Note that we pass an object to params, the card won't be available if page is reloaded.
    // It will then think that we are going to create a new card. See computed title.
    console.log("card", this.card);
    this.cardForm = this.cardToForm(this.card);
  },
  beforeRouteLeave(to, from, next) {
    // When going back home, notify the action in the card
    if (from.name === "EditCard" && to.name === "Home") {
      EventBus.$emit("card-updated", this.buildCardUpdate());
    }
    next();
  },
  methods: {
    deleteCard() {
      EventBus.$emit("card-updated", {
        action: CardUpdateAction.delete,
        card: this.card
      });
      this.$router.go(-1); // go back to CardList
    },
    buildCardUpdate() {
      let card = this.formToCard(this.cardForm);
      return {
        action: this.decideAction(card),
        card: card
      };
    },
    decideAction(card) {

      if (card.hints.length === 0)
        return CardUpdateAction.nothing;

      if (!this.card)
        return CardUpdateAction.update;

      if (Util.getCardRawContent(card) === Util.getCardRawContent(this.card))
        return CardUpdateAction.nothing;

      return CardUpdateAction.update;
    },
    formToCard(cardForm) {
      return {
        id: cardForm.id,
        hints: cardForm.hints.split("\n").map(hint => hint.trim()).filter(it => !!it),
        notes: cardForm.notes,
        score: cardForm.score,
        tags: cardForm.tags.trim().split(/[, ]+/).filter(it => !!it)
      };
    },
    cardToForm(card) {
      if (card) {
        return {
          id: card.id,
          hints: card.hints.join("\n"),
          score: card.score,
          notes: card.notes,
          tags: card.tags.join(" ")
        };
      } else {
        return {
          id: null,
          hints: "",
          score: 50,
          notes: "",
          tags: ""
        };
      }
    }
  }
};
</script>
