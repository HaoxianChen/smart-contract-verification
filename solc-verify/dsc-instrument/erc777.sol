// SPDX-License-Identifier: MIT
//pragma solidity ^0.8.0;

/**
* @notice invariant forall (address p, address o) (! (operators[p][o].b && defaultOperator[o].b))
*/

contract Erc777 {
  struct RevokedDefaultOperatorTuple {
    bool b;
    bool _valid;
  }
  struct DefaultOperatorTuple {
    bool b;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct OperatorsTuple {
    bool b;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct InconsistentOperatorKeyTuple {
    address p;
    address o;
  }
  mapping(address=>mapping(address=>RevokedDefaultOperatorTuple)) revokedDefaultOperator;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>DefaultOperatorTuple) defaultOperator;
  OwnerTuple owner;
  mapping(address=>mapping(address=>OperatorsTuple)) operators;
  TotalSupplyTuple totalSupply;
  InconsistentOperatorKeyTuple[] inconsistentOperatorKeyArray;
  event OperatorBurn(address p,address s,uint n,uint data,uint operatorData);
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event OperatorSend(address o,address r,address s,uint n,uint data,uint operatorData);
  event RevokedDefaultOperator(address p,address o,bool b);
  event Operators(address p,address o,bool b);
  event Transfer(address from,address to,uint amount);
  constructor(address[] memory defaultOperators_) public {
    for (uint256 i = 0; i < defaultOperators_.length; i++) {
        defaultOperator[defaultOperators_[i]].b = true;
    }
    updateTotalSupplyOnInsertConstructor_r15();
    updateOwnerOnInsertConstructor_r11();
  }
  function approve(address s,uint n) public    {
      bool r29 = updateIncreaseAllowanceOnInsertRecv_approve_r29(s,n);
      if(r29==false) {
        revert("Rule condition failed");
      }
  }
  function revokeDefaultOperator(address o) public    {
      bool r25 = updateOperatorsOnInsertRecv_revokeDefaultOperator_r25(o);
      bool r23 = updateRevokedDefaultOperatorOnInsertRecv_revokeDefaultOperator_r23(o);
      if(r25==false && r23==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function getRevokedDefaultOperator(address p,address o) public view  returns (bool) {
      RevokedDefaultOperatorTuple memory revokedDefaultOperatorTuple = revokedDefaultOperator[p][o];
      bool b = revokedDefaultOperatorTuple.b;
      return b;
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function approveOperator(address o) public    {
      bool r16 = updateRevokedDefaultOperatorOnInsertRecv_approveOperator_r16(o);
      bool r9 = updateOperatorsOnInsertRecv_approveOperator_r9(o);
      if(r16==false && r9==false) {
        revert("Rule condition failed");
      }
  }
  function getOperators(address p,address o) public view  returns (bool) {
      OperatorsTuple memory operatorsTuple = operators[p][o];
      bool b = operatorsTuple.b;
      return b;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function getDefaultOperator(address p) public view  returns (bool) {
      DefaultOperatorTuple memory defaultOperatorTuple = defaultOperator[p];
      bool b = defaultOperatorTuple.b;
      return b;
  }
  function burn(address p,uint amount) public    {
      bool r7 = updateBurnOnInsertRecv_burn_r7(p,amount);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r27 = updateMintOnInsertRecv_mint_r27(p,amount);
      if(r27==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r30 = updateTransferFromOnInsertRecv_transferFrom_r30(from,to,amount);
      if(r30==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r20 = updateTransferOnInsertRecv_transfer_r20(to,amount);
      if(r20==false) {
        revert("Rule condition failed");
      }
  }
  function updateAllowanceOnIncrementAllowanceTotal_r26(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r13(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r26(o,s,delta);
  }
  function updateOperatorsOnInsertRecv_revokeDefaultOperator_r25(address o) private   returns (bool) {
      if(true) {
        address p = msg.sender;
        if(true) {
          operators[p][o] = OperatorsTuple(false,true);
          emit Operators(p,o,false);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r15() private    {
      if(true) {
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateTotalInOnInsertTransfer_r12(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r8(p,delta);
  }
  function updateTotalMintOnInsertMint_r18(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r8(p,delta);
  }
  function updateAllowanceOnIncrementSpentTotal_r26(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateMintOnInsertRecv_mint_r27(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllMintOnInsertMint_r3(n);
            updateTotalMintOnInsertMint_r18(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r20(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m) {
            updateTotalOutOnInsertTransfer_r21(s,n);
            updateTotalInOnInsertTransfer_r12(r,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalBurn_r8(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBurnOnInsertBurn_r17(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r8(p,delta);
  }
  function updateBalanceOfOnIncrementTotalOut_r8(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllBurn_r19(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateSpentTotalOnInsertTransferFrom_r22(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r26(o,s,delta);
  }
  function updateTotalSupplyOnIncrementAllMint_r19(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllBurnOnInsertBurn_r31(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r19(delta);
  }
  function updateOwnerOnInsertConstructor_r11() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateBalanceOfOnIncrementTotalMint_r8(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalOutOnInsertTransfer_r21(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r8(p,delta);
  }
  function updateAllMintOnInsertMint_r3(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r19(delta);
  }
  function updateBurnOnInsertRecv_burn_r7(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateAllBurnOnInsertBurn_r31(n);
              updateTotalBurnOnInsertBurn_r17(p,n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateRevokedDefaultOperatorOnInsertRecv_revokeDefaultOperator_r23(address o) private   returns (bool) {
      if(true) {
        address p = msg.sender;
        DefaultOperatorTuple memory defaultOperatorTuple = defaultOperator[o];
        if(true==defaultOperatorTuple.b) {
          if(true) {
            revokedDefaultOperator[p][o] = RevokedDefaultOperatorTuple(true,true);
            emit RevokedDefaultOperator(p,o,true);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r30(address o,address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint k = allowanceTuple.n;
          BalanceOfTuple memory balanceOfTuple = balanceOf[o];
          if(true) {
            uint m = balanceOfTuple.n;
            if(m>=n && k>=n) {
              updateTransferOnInsertTransferFrom_r0(o,r,n);
              updateSpentTotalOnInsertTransferFrom_r22(o,s,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r12(r,n);
        updateTotalOutOnInsertTransfer_r21(o,n);
        emit Transfer(o,r,n);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateOperatorsOnInsertRecv_approveOperator_r9(address o) private   returns (bool) {
      if(true) {
        address p = msg.sender;
        if(true) {
          operators[p][o] = OperatorsTuple(true,true);
          emit Operators(p,o,true);
          return true;
        }
      }
      return false;
  }
  function updateRevokedDefaultOperatorOnInsertRecv_approveOperator_r16(address o) private   returns (bool) {
      if(true) {
        address p = msg.sender;
        DefaultOperatorTuple memory defaultOperatorTuple = defaultOperator[o];
        if(true==defaultOperatorTuple.b) {
          if(true) {
            revokedDefaultOperator[o][p] = RevokedDefaultOperatorTuple(false,true);
            emit RevokedDefaultOperator(o,p,false);
            return true;
          }
        }
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r29(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r13(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r8(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }

  //function operatorConsistency(address p, address o) public view {
      //assert( ! (operators[p][o].b && defaultOperator[o].b)); 
  //}
}
