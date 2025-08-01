<script lang="ts">
	import type { Live } from "live_svelte";

    let { number, live }: { number: number, live: Live } = $props();

    let customCount = $state(number);

    function increase() {
        live.pushEvent("set_number", {number: number + 1}, () => {})
        customCount += 1;
    }

    function decrease() {
        live.pushEvent("set_number", {number: number - 1}, () => {})
        customCount -= 1;
    }

    let fullString = $derived(`Server: ${number} | Custom: ${customCount}`);
</script>

<p>The number is {fullString}</p>
<button onclick={increase}>+</button>
<button onclick={decrease}>-</button>
