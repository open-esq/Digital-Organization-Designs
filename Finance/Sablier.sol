pragma solidity 0.5.9;

/// @title ERC-1620 Money Streaming Standard
/// @dev See https://github.com/ethereum/eips/issues/1620

interface IERC1620 {

    /// @dev This emits when streams are successfully created and added
    ///  in the mapping object.
    event CreateStream(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        address tokenAddress,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment,
        uint256 interval
    );

    /// @dev This emits when the receiver of a stream withdraws a portion
    ///  or all of their available funds from an ongoing stream, without
    ///  stopping it. Note that we don't emit both the sender and the
    ///  recipient's balance because only the recipient can withdraw
    ///  while the stream is active.
    event WithdrawFromStream(
        uint256 indexed streamId,
        address indexed recipient,
        uint256 amount
    );

    /// @dev This emits when a stream is successfully redeemed and
    ///  all involved parties get their share of the available funds.
    event RedeemStream(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        uint256 senderAmount,
        uint256 recipientAmount
    );

    /// @dev This emits when an update is successfully committed by
    ///  one of the involved parties.
    event ConfirmUpdate(
        uint256 indexed streamId,
        address indexed confirmer,
        address newTokenAddress,
        uint256 newStopBlock,
        uint256 newPayment,
        uint256 newInterval
    );

    /// @dev This emits when one of the involved parties revokes
    ///  a proposed update to the stream.
    event RevokeUpdate(
        uint256 indexed streamId,
        address indexed revoker,
        address newTokenAddress,
        uint256 newStopBlock,
        uint256 newPayment,
        uint256 newInterval
    );

    /// @dev This emits when an update (that is, modifications to
    ///  payment rate, starting or stopping block) is successfully
    ///  approved by all involved parties.
    event ExecuteUpdate(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        address newTokenAddress,
        uint256 newStopBlock,
        uint256 newPayment,
        uint256 newInterval
    );

    /// @notice Creates a new stream between `msg.sender` and `_recipient`
    /// @dev Throws unless `msg.value` is exactly
    ///  `_payment * ((_stopBlock - _startBlock) / _interval)`.
    ///  Throws if `_startBlock` is not higher than `block.number`.
    ///  Throws if `_stopBlock` is not higher than `_startBlock`.
    ///  Throws if the total streaming duration `_stopBlock - _startBlock`
    ///  is not a multiple of `_interval`.
    /// @param _recipient The stream sender or the payer
    /// @param _recipient The stream recipient or the payee
    /// @param _tokenAddress The token contract address
    /// @param _startBlock The starting time of the stream
    /// @param _stopBlock The stopping time of the stream
    /// @param _payment How much money moves from sender to recipient
    /// @param _interval How often the `payment` moves from sender to recipient
    function createStream(
        address _sender,
        address _recipient,
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
    external;

    /// @notice Withdraws all or a fraction of the available funds
    /// @dev If the stream ended and the recipient withdraws the deposit in full,
    ///  the stream object gets deleted after this operation
    ///  to save gas for the user and optimise contract storage.
    ///  Throws if `_streamId` doesn't point to a valid stream.
    ///  Throws if `msg.sender` is not the recipient of the given `streamId`
    /// @param _streamId The stream to withdraw from
    /// @param _funds The amount of money to withdraw
    function withdrawFromStream(
        uint256 _streamId,
        uint256 _funds
    )
    external;

    /// @notice Redeems the stream by distributing the funds to the sender and the recipient
    /// @dev The stream object gets deleted after this operation
    ///  to save gas for the user and optimise contract storage.
    ///  Throws if `_streamId` doesn't point to a valid stream.
    ///  Throws unless `msg.sender` is either the sender or the recipient
    ///  of the given `streamId`.
    /// @param _streamId The stream to stop
    function redeemStream(
        uint256 _streamId
    )
    external;

    /// @notice Signals one party's willingness to update the stream
    /// @dev Throws if `_streamId` doesn't point to a valid stream.
    ///  Not executed prior to everyone agreeing to the new terms.
    ///  In terms of validation, it works exactly the same as the `createStream` function.
    /// @param _streamId The stream to update
    /// @param _tokenAddress The token contract address
    /// @param _stopBlock The new stopping time of the stream
    /// @param _payment How much money moves from sender to recipient
    /// @param _interval How often the `payment` moves from sender to recipient
    function confirmUpdate(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
    external;

    /// @notice Revokes an update proposed by one of the involved parties
    /// @dev Throws if `_streamId` doesn't point to a valid stream. The parameters
    ///  are merely for logging purposes.
    function revokeUpdate(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
    external;

    /// @notice Returns available funds for the given stream id and address
    /// @dev Streams assigned to the zero address are considered invalid, and
    ///  this function throws for queries about the zero address.
    /// @param _streamId The stream for whom to query the balance
    /// @param _addr The address for whom to query the balance
    /// @return The total funds available to `addr` to withdraw
    function balanceOf(
        uint256 _streamId,
        address _addr
    )
    external
    view
    returns (
        uint256 balance
    );

    /// @notice Returns the full stream data
    /// @dev Throws if `_streamId` doesn't point to a valid stream.
    /// @param _streamId The stream to return data for
    function getStream(
        uint256 _streamId
    )
    external
    view
    returns (
        address _sender,
        address _recipient,
        address _tokenAddress,
        uint256 _balance,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    );
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

/// @title Sablier - ERC Money Streaming Implementation
/// @author Paul Berg - <hello@paulrberg.com>

contract Sablier is IERC1620 {
    using SafeMath for uint256;

    /**
     * Types
     */
    struct Timeframe {
        uint256 start;
        uint256 stop;
    }

    struct Rate {
        uint256 payment;
        uint256 interval;
    }

    struct Stream {
        address sender;
        address recipient;
        address tokenAddress;
        Timeframe timeframe;
        Rate rate;
        uint256 balance;
    }

    /**
     * Storage
     */
    mapping(uint256 => Stream) private streams;
    uint256 private streamNonce;
    mapping(uint256 => mapping(address => bool)) private updates;

    /**
     * Events
     */
    event CreateStream(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        address tokenAddress,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment,
        uint256 interval,
        uint256 deposit
    );

    event WithdrawFromStream(
        uint256 indexed streamId,
        address indexed recipient,
        uint256 amount
    );

    event RedeemStream(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        uint256 senderAmount,
        uint256 recipientAmount
    );

    event ConfirmUpdate(
        uint256 indexed streamId,
        address indexed confirmer,
        address newTokenAddress,
        uint256 newStopBlock,
        uint256 newPayment,
        uint256 newInterval
    );

    event RevokeUpdate(
        uint256 indexed streamId,
        address indexed revoker,
        address newTokenAddress,
        uint256 newStopBlock,
        uint256 newPayment,
        uint256 newInterval
    );

    event ExecuteUpdate(
        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        address newTokenAddress,
        uint256 newStopBlock,
        uint256 newPayment,
        uint256 newInterval
    );

    /*
    * Modifiers
    */
    modifier onlyRecipient(uint256 _streamId) {
        require(
            streams[_streamId].recipient == msg.sender,
            "only the stream recipient is allowed to perform this action"
        );
        _;
    }

    modifier onlySenderOrRecipient(uint256 _streamId) {
        require(
            msg.sender == streams[_streamId].sender ||
            msg.sender == streams[_streamId].recipient,
            "only the sender or the recipient of the stream can perform this action"
        );
        _;
    }

    modifier streamExists(uint256 _streamId) {
        require(
            streams[_streamId].sender != address(0x0), "stream doesn't exist");
        _;
    }

    modifier updateConfirmed(uint256 _streamId, address _addr) {
        require(
            updates[_streamId][_addr] == true,
            "msg.sender has not confirmed the update"
        );
        _;
    }

    /**
     * Functions
     */
    constructor() public {
        streamNonce = 1;
    }

    function balanceOf(uint256 _streamId, address _addr)
    public
    view
    streamExists(_streamId)
    returns (uint256 balance)
    {
        Stream memory stream = streams[_streamId];
        uint256 deposit = depositOf(_streamId);
        uint256 delta = deltaOf(_streamId);
        uint256 funds = delta.div(stream.rate.interval).mul(stream.rate.payment);

        if (stream.balance != deposit)
            funds = funds.sub(deposit.sub(stream.balance));

        if (_addr == stream.recipient) {
            return funds;
        } else if (_addr == stream.sender) {
            return stream.balance.sub(funds);
        } else {
            return 0;
        }
    }

    function getStream(uint256 _streamId)
    public
    view
    streamExists(_streamId)
    returns (
        address sender,
        address recipient,
        address tokenAddress,
        uint256 balance,
        uint256 startBlock,
        uint256 stopBlock,
        uint256 payment,
        uint256 interval
    )
    {
        Stream memory stream = streams[_streamId];
        return (
            stream.sender,
            stream.recipient,
            stream.tokenAddress,
            stream.balance,
            stream.timeframe.start,
            stream.timeframe.stop,
            stream.rate.payment,
            stream.rate.interval
        );
    }

    function getUpdate(uint256 _streamId, address _addr)
    public
    view
    streamExists(_streamId)
    returns (bool active)
    {
        return updates[_streamId][_addr];
    }

    function createStream(
        address _sender,
        address _recipient,
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        public
    {
        verifyTerms(
            _tokenAddress,
            _startBlock,
            _stopBlock,
            _interval
        );

        // only ERC20 tokens can be streamed
        uint256 deposit = _stopBlock.sub(_startBlock).div(_interval).mul(_payment);
        IERC20 tokenContract = IERC20(_tokenAddress);
        uint256 allowance = tokenContract.allowance(_sender, address(this));
        require(allowance >= deposit, "contract not allowed to transfer enough tokens");

        // create and log the stream if the deposit is okay
        streams[streamNonce] = Stream({
            balance : deposit,
            sender : _sender,
            recipient : _recipient,
            tokenAddress : _tokenAddress,
            timeframe : Timeframe(_startBlock, _stopBlock),
            rate : Rate(_payment, _interval)
        });
        emit CreateStream(
            streamNonce,
            _sender,
            _recipient,
            _tokenAddress,
            _startBlock,
            _stopBlock,
            _payment,
            _interval,
            deposit
        );
        streamNonce = streamNonce.add(1);

        // apply Checks-Effects-Interactions
        require(tokenContract.transferFrom(_sender, address(this), deposit), "initial deposit failed");
    }

    function withdrawFromStream(
        uint256 _streamId,
        uint256 _amount
    )
    public
    streamExists(_streamId)
    onlyRecipient(_streamId)
    {
        Stream memory stream = streams[_streamId];
        uint256 availableFunds = balanceOf(_streamId, stream.recipient);
        require(availableFunds >= _amount, "not enough funds");

        streams[_streamId].balance = streams[_streamId].balance.sub(_amount);
        emit WithdrawFromStream(_streamId, stream.recipient, _amount);

        // saving gas
        if (streams[_streamId].balance == 0) {
            delete streams[_streamId];
            updates[_streamId][stream.sender] = false;
            updates[_streamId][stream.recipient] = false;
        }

        // saving gas by checking beforehand
        if (_amount > 0)
            require(IERC20(stream.tokenAddress).transfer(stream.recipient, _amount), "erc20 transfer failed");
    }

    function redeemStream(uint256 _streamId)
    public
    streamExists(_streamId)
    onlySenderOrRecipient(_streamId)
    {
        Stream memory stream = streams[_streamId];
        uint256 senderAmount = balanceOf(_streamId, stream.sender);
        uint256 recipientAmount = balanceOf(_streamId, stream.recipient);
        emit RedeemStream(
            _streamId,
            stream.sender,
            stream.recipient,
            senderAmount,
            recipientAmount
        );

        // saving gas
        delete streams[_streamId];
        updates[_streamId][stream.sender] = false;
        updates[_streamId][stream.recipient] = false;

        IERC20 tokenContract = IERC20(stream.tokenAddress);
        // saving gas by checking beforehand
        if (recipientAmount > 0)
            require(tokenContract.transfer(stream.recipient, recipientAmount), "erc20 transfer failed");
        if (senderAmount > 0)
            require(tokenContract.transfer(stream.sender, senderAmount), "erc20 transfer failed");
    }

    function confirmUpdate(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
    public
    streamExists(_streamId)
    onlySenderOrRecipient(_streamId)
    {
        onlyNewTerms(
            _streamId,
            _tokenAddress,
            _stopBlock,
            _payment,
            _interval
        );
        verifyTerms(
            _tokenAddress,
            block.number,
            _stopBlock,
            _interval
        );

        emit ConfirmUpdate(
            _streamId,
            msg.sender,
            _tokenAddress,
            _stopBlock,
            _payment,
            _interval
        );
        updates[_streamId][msg.sender] = true;

        executeUpdate(
            _streamId,
            _tokenAddress,
            _stopBlock,
            _payment,
            _interval
        );
    }

    function revokeUpdate(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        public
        updateConfirmed(_streamId, msg.sender)
    {
        emit RevokeUpdate(
            _streamId,
            msg.sender,
            _tokenAddress,
            _stopBlock,
            _payment,
            _interval
        );
        updates[_streamId][msg.sender] = false;
    }

    /**
     * Private
     */
    function deltaOf(uint256 _streamId)
    private
    view
    returns (uint256 delta)
    {
        Stream memory stream = streams[_streamId];
        uint256 startBlock = stream.timeframe.start;
        uint256 stopBlock = stream.timeframe.stop;

        // before the start of the stream
        if (block.number <= startBlock)
            return 0;

        // during the stream
        if (block.number <= stopBlock)
            return block.number - startBlock;

        // after the end of the stream
        return stopBlock - startBlock;
    }

    function depositOf(uint256 _streamId)
    private
    view
    returns (uint256 funds)
    {
        Stream memory stream = streams[_streamId];
        return stream.timeframe.stop
            .sub(stream.timeframe.start)
            .div(stream.rate.interval)
            .mul(stream.rate.payment);
    }

    function onlyNewTerms(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
    private
    view
    returns (bool valid)
    {
        require(
            streams[_streamId].tokenAddress != _tokenAddress ||
            streams[_streamId].timeframe.stop != _stopBlock ||
            streams[_streamId].rate.payment != _payment ||
            streams[_streamId].rate.interval != _interval,
            "stream has these terms already"
        );
        return true;
    }

    function verifyTerms(
        address _tokenAddress,
        uint256 _startBlock,
        uint256 _stopBlock,
        uint256 _interval
    )
    private
    view
    returns (bool valid)
    {
        require(
            _tokenAddress != address(0x0),
            "token contract address needs to be provided"
        );
        require(
            _startBlock >= block.number,
            "the start block needs to be higher than the current block number"
        );
        require(
            _stopBlock > _startBlock,
            "the stop block needs to be higher than the start block"
        );
        uint256 delta = _stopBlock - _startBlock;
        require(
            delta >= _interval,
            "the block difference needs to be higher than the payment interval"
        );
        require(
            delta.mod(_interval) == 0,
            "the block difference needs to be a multiple of the payment interval"
        );
        return true;
    }

    function executeUpdate(
        uint256 _streamId,
        address _tokenAddress,
        uint256 _stopBlock,
        uint256 _payment,
        uint256 _interval
    )
        private
        streamExists(_streamId)
    {
        Stream memory stream = streams[_streamId];
        if (updates[_streamId][stream.sender] == false)
            return;
        if (updates[_streamId][stream.recipient] == false)
            return;

        // adjust stop block
        uint256 remainder = _stopBlock.sub(block.number).mod(_interval);
        uint256 adjustedStopBlock = _stopBlock.sub(remainder);
        emit ExecuteUpdate(
            _streamId,
            stream.sender,
            stream.recipient,
            _tokenAddress,
            adjustedStopBlock,
            _payment,
            _interval
        );
        updates[_streamId][stream.sender] = false;
        updates[_streamId][stream.recipient] = false;

        redeemStream(_streamId);
        createStream(
            stream.sender,
            stream.recipient,
            _tokenAddress,
            block.number,
            adjustedStopBlock,
            _payment,
            _interval
        );
    }
}
