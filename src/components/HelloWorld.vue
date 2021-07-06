
<template>
  <div class="hello">
    <button @click="fetchGreeting">Fetch Greeting</button>
    <button @click="setGreeting">Set Greeting</button>
    <button @click="setCounter">Set Counter</button>
    <input v-model="gt" />
  </div>
</template>

<script>
// import Greeter from "../artifacts/contracts/Greeter.sol/Greeter.json";
import Greeter from "../../artifacts/contracts/Greeter.sol/Greeter.json";
import { ethers } from "ethers";
const greeterAddress = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";

export default {
  name: "HelloWorld",
  props: {
    msg: String,
  },
  data() {
    return {
      gt: "",
    };
  },
  methods: {
    // 获取账号
    async requestAccount() {
      await window.ethereum.request({ method: "eth_requestAccounts" });
    },
    // 获取greet值
    async fetchGreeting() {
      if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(
          greeterAddress,
          Greeter.abi,
          provider
        );
        try {
          const data = await contract.greet();
          const data2 = await contract.count();
          console.log("data: ", data, data2);
        } catch (err) {
          console.log("error: ", err);
        }
      }
    },
    // 修改greet值
    async setGreeting() {
      if (!this.gt) return;

      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
          greeterAddress,
          Greeter.abi,
          signer
        );
        console.log(this.gt);
        const transaction = await contract.setGreeting(this.gt);
        this.gt = "";
        await transaction.wait();
        this.fetchGreeting();
      }
    },
    async setCounter() {
      if (!this.gt) return;

      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
          greeterAddress,
          Greeter.abi,
          signer
        );
        console.log(this.gt);
        const transaction = await contract.setCounter(this.gt + "test");
        this.gt = "";
        await transaction.wait();
        this.fetchGreeting();
      }
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
