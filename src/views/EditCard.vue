<template>
  <div v-if="card">Card will be edited here: {{ card.hints[0] }}</div>
</template>

<script>
export default {
  data: () => ({
    card: null
  }),
  created() {
    if (this.$route.params.card) {
      this.card = this.$route.params.card;
    } else {
      // This page was probably reloaded so we don't have the card param.
      // Just go Home to reload card list.
      this.$router.push({ name: "Home" });
    }
  }
};
</script>
