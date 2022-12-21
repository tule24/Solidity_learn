/*  ERC - Ethereum request comment

    * ERC 20: Token Standard => for fungible asset => address
        - Function:
            + name
            + symbol
            + decimals
            + totalSupply
            + balanceOf
            + transfer
            + transferFrom
            + approve
            + allowance
        - Event:
            + Transfer
            + Approval
    
    * ERC 223: Advance version of ERC 20
    => Giải quyết các vấn đề của ERC 20
    - Mất token: ERC20 có 2 cách chuyển token tùy thuộc vào địa chỉ nhận là wallet hay contract
    Nếu là wallet thì sẽ gọi transfer để gửi token tới wallet. Nếu là contract thì sẽ gọi hàm approve trên contract token,
    sau đó gọi transferFrom trên receiver contract để nhận token. Nếu gọi transfer tới contract address => mất token
    - Không có thông báo khi chuyển tiền tới receiver
    - Tối ưu việc giao tiếp giữa các address-to-contract: Bình thường gọi approve xong gọi transferFrom => 2 transaction
    khác nhau address-to-contract nhưng với ERC223 thì chỉ có 1 transaction thôi address-to-address
    - Giúp việc giao dịch token sẽ giống như việc giao dịch ether hơn

    * ERC 165: Standard Interface Detection
    * ERC 1820: Pseudo-introspection Registry Contract
    * ERC 777: Token Standard
    => Bản nâng cập của ERC 20
    - delegated transfer => operator
    - send/receive hook 
    - ERC 777 dùng ERC 1820 để đăng ký
    ____________________________________________
    |_________________Sender___________________|
                ||  send()
    ____________\/_____________________________
    |______________ERC777______________________|
                || getInterfaceImplement    ||
    ____________\/___________________       ||    
    |_______Registry (ERC 1820)_____|       ||   tokenReceived()
                                            ||
    ________________________________________\/__
    |_____________________Recipient_____________|       
    
    * ERC 721: Non-Fungible Token Standard => for non-fungible assets => address + tokenId
    * ERC 1155: Multi Token Standard
    * ERC 1400: Security Token Standards
    => It contains 4 other standards:
        - ERC 1594: Core standard
        - ERC 1410: Tokens partition
        - ERC 1643: Attach documents
        - ERC 1644: Forced token transfers
*/