import { useEffect, useState } from "react";
import { useAccount } from "wagmi";
import Web3 from "web3";
import { newKit } from "@celo/contractkit";
import LotteryABI from '../Lottery.json';
import GameABI from '../DailyGame.json';

type StateMutabilityType = "pure" | "view" | "nonpayable" | "payable";

interface ABIItem {
    inputs?: [];
    name?: string;
    outputs?: [];
    stateMutability?: StateMutabilityType;
    type: any;
    
    // Function-specific properties
    constant?: boolean;
    payable?: boolean;
    anonymous?: boolean;

    // Event-specific properties
    indexed?: boolean;
    signature?: string;
}

export default function Home() {
    // const [userAddress, setUserAddress] = useState("");
    // const [isMounted, setIsMounted] = useState(false);
    // const { address, isConnected } = useAccount();

    // const web3 = new Web3("https://alfajores-forno.celo-testnet.org");
    // const kit = newKitFromWeb3(web3);

    // const contractAddress = '0x5bb2c0bca2140261a3ca4b06faf08d69837a9cb3'; // Replace with your contract address
    // // const contract = new kit.web3.eth.Contract(GameABI.abi, contractAddress);
    // let x = kit.web3.eth.getAccounts().then(data => {
    //     console.log(data);
    // });

    // console.log(x);

    // useEffect(() => {
    //     setIsMounted(true);
    // }, []);

    // useEffect(() => {
    //     if (isConnected && address) {
    //         setUserAddress(address);
    //     }
    // }, [address, isConnected]);

    // if (!isMounted) {
    //     return null;
    // }

    // return (
    //     <div className="flex flex-col justify-center items-center">
    //         <div className="h1">
    //             There you go... a celo for your next Celo project!
    //         </div>
    //         {isConnected ? (
    //             <div className="h2 text-center">
    //                 Your address: {userAddress}
    //             </div>
    //         ) : (
    //             <div>No Wallet Connected</div>
    //         )}
    //     </div>
    // );

    const [kit, setKit] = useState<any>(null);
    const [contract, setContract] = useState<any>(null);
    const [account, setAccount] = useState<string>('');
    const [points, setPoints] = useState<number>(0);
    
    useEffect(() => {
        const init = async () => {
            const newKitInstance = newKit('https://alfajores-forno.celo-testnet.org');
            setKit(newKitInstance);
            try {
                const accounts = await newKitInstance.web3.eth.getAccounts();
                console.log(accounts);
                setAccount(accounts[0]);
                const deployedNetwork = "0xa8cDf63a70a7E19AF542FF33500f27389358a331"; // Replace with the actual deployed contract address
                const contractInstance = new newKitInstance.web3.eth.Contract(
                    GameABI.abi as ABIItem[],
                    deployedNetwork,
                );
                setContract(contractInstance);
            } catch (error) {
                console.error('Error while connecting to Celo network:', error);
            }
        };
        init();
    }, []);

    const addPoints = async () => {
        try {
            // Assume pointsToAdd is already defined elsewhere
            const tx = await contract.methods.addPoints(10).send({ from: account });
            console.log('Points added successfully. Transaction hash:', tx.transactionHash);
        } catch (error) {
            console.error('Error while adding points:', error);
        }
    };

    const declareWinner = async () => {
        try {
            const tx = await contract.methods.declareWinner().send({ from: account });
            console.log('Winner declared successfully. Transaction hash:', tx.transactionHash);
        } catch (error) {
            console.error('Error while declaring winner:', error);
        }
    };

    return (
        <div>
            <h1>Game Component</h1>
            <p>Account: {account}</p>
            <button onClick={addPoints}>Add Points</button>
            <button onClick={declareWinner}>Declare Winner</button>
        </div>
    );
}
