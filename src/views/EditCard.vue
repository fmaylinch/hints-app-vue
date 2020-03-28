<template>
  <div v-if="card">
    <div>Card will be edited here: {{ card.hints[0] }}</div>
    <div>{{cards.length}} cards total</div>
  </div>
</template>

<script>
export default {
  props: {
    cards: { type: Array, required: true }
  },
  data: () => ({
    card: null
  }),
  created() {
    if (this.$route.params.card) {
      this.card = this.$route.params.card;
    } else {
      // Note that we pass an object to params, so this page won't work when reloaded
      // because the card won't be available. Just go Home to display the card list.
      this.$router.push({ name: "Home" });
    }
  }
};
</script>
