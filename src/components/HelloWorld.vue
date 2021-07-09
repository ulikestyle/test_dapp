
<template>
  <div class="hello">
    <button @click="createNFT">nft</button>
    <button @click="getBlance">get balance</button>
    <button @click="setApproved">get approved</button>
    <button @click="transfer">transfer</button>
    <input v-model="gt" />
  </div>
</template>

<script>
import MayaCollectible from "../../artifacts/contracts/MayaCollectible.sol/MayaCollectible.json";
import { ethers } from "ethers";
const mayaAddress = "0xae0FF445E2Ea570064FF641341f274E99987cFaa";

export default {
  name: "HelloWorld",
  props: {
    msg: String,
  },
  data() {
    return {
      gt: "",
      tokenId: -1,
    };
  },
  methods: {
    // 获取账号
    async requestAccount() {
      await window.ethereum.request({ method: "eth_requestAccounts" });
    },
    // 创建nft
    async createNFT() {
      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        const [account] = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        let tokenUri =
          "https://gateway.pinata.cloud/ipfs/QmRyhU31QeHmiAvnUWhDMi7AsF5fJHY5byZsDbVPQxEkhg";
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
          mayaAddress,
          MayaCollectible.abi,
          signer
        );
        console.log(account);
        console.log(tokenUri);
        const transaction = await contract.awardItem(account, tokenUri);
        const data = await transaction.wait();
        this.tokenId = data.events[0].args.tokenId;
        console.log("tokenid", data.events[0].args.tokenId.toString());
      }
    },
    // nft 拥有的数量
    async getBlance() {
      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        const [account] = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(
          mayaAddress,
          MayaCollectible.abi,
          provider
        );
        const count = await contract.balanceOf(account);
        console.log("has:", count.toString());
      }
    },
    // 获取授权
    async setApproved() {
      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        const [account] = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
          mayaAddress,
          MayaCollectible.abi,
          signer
        );
        await contract.approve(account, this.tokenId);
        console.log(account, "has approved ", this.tokenId);
      }
    },
    // 交易
    async transfer() {
      const otherAccount = "0x5F1a9e86AD25190c0388c2C62F92BfD5Ad1E1277";
      // function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        const [account] = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
          mayaAddress,
          MayaCollectible.abi,
          signer
        );
        console.log("start transfer");
        const transaction = await contract.transferFrom(
          account,
          otherAccount,
          this.tokenId
        );
        await transaction.wait();
        console.log(account, "has transfer to", otherAccount, this.tokenId);
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
