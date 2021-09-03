pragma solidity ^0.8.7;

contract Tshirts{ 
uint public orderid;
struct order{ 
	uint id;
	uint quant; 
	uint price;
	bool paymentstatus;
} 


order []orders; 
event accepted(address, uint, uint );
event paid(address, uint);
mapping(uint => address)public worder;

function placeorder(uint q) public{
    orderid++;
    order memory t = order(orderid, q, q*250, false);
    orders.push(t);
    worder[orderid] = msg.sender;
    
}
    
function getorderid() public view returns(uint[] memory) {
    uint i;
    uint a = orders.length;
    uint[] memory temp = new uint[](a);
    for(i = 0; i<orders.length; i++){
        order memory t = orders[i];
        temp[i] = t.id;
    }
    return(temp);
}


function acceptorder(uint aid) public returns(uint, uint){
   require(msg.sender != worder[aid]);
   uint i; 
	for(i=0;i<orders.length;i++) 
	{ 
		order memory t = orders[i]; 
		if(t.id==aid) 
		{ 
		    require(t.paymentstatus == true);
		    emit accepted(msg.sender, t.id, t.price);
		    require (i < orders.length);
		    orders[i] = orders[orders.length-1];
		    delete orders[orders.length-1];
		    orders.length--;
			return(t.id, t.price);
		} 
	} 
	return(0, 0); 
   
}

function payment(uint aid) public{
    require(msg.sender == worder[aid]);
    uint i;
    for(i=0; i<orders.length; i++){
        order memory t = orders[i];
        if(t.id == aid){
            orders[i].paymentstatus = true;
            emit paid(msg.sender, t.price);
        }
    }
}
}

