
<template>
  <div class="hello">
    <button @click="createNFT">nft</button>
    <button @click="getBlance">get balance</button>
    <button @click="setApproved">get approved</button>
    <button @click="transfer">transfer</button>
    <button @click="getOwner">getOwner</button>
    <div>
      <p>gt</p>
      <input v-model="gt" />
    </div>
    <div>
      <p>tokenID</p>
      <input v-model="tokenId" />
    </div>
    <div>
      <p>otherAddress</p>
      <input v-model="otherAddress" />
    </div>
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
      tokenId: "10",
      otherAddress: "",
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
        ethers.BigNumber
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
        const owner_address = await contract.ownerOf(ethers.BigNumber.from(this.tokenId))
        console.log(owner_address)
        console.log(account)
        if (owner_address.toLowerCase() === account) {
          console.log("cant approve by yourself")
          return
        }

        const tokenId = ethers.BigNumber.from(this.tokenId)

        await contract.approve(account, tokenId);
        console.log(account, "has approved ", this.tokenId);
      }
    },
    // 交易
    async transfer() {
      // const otherAccount = "0x64edb5045866dfa907d978eeBD54F38beb2CE0F9"; //dongdong account
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
        // const transaction = await contract.transferFrom(
        //   account,
        //   otherAccount,
        //   this.tokenId
        // );
        const tokenId = ethers.BigNumber.from(this.tokenId)
        // const approved = await contract.getApproved(this.tokenId)
        // if (!approved) {
        //   console.log(this.tokenId, "is not approved by", account)
        //   return
        // }

        const transaction = await contract["safeTransferFrom(address,address,uint256)"](account, this.otherAddress, tokenId);
        await transaction.wait();
        console.log(account, "has transfer to", this.otherAddress, this.tokenId);
      }
    },

    // owner
    async getOwner() {
      if (typeof window.ethereum !== "undefined") {
        await this.requestAccount();
        // const [account] = await window.ethereum.request({
        //   method: "eth_requestAccounts",
        // });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(
          mayaAddress,
          MayaCollectible.abi,
          provider,
        );
        const owner_address = await contract.ownerOf(ethers.BigNumber.from(this.tokenId))
        console.log("owner_address is:", owner_address);
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
