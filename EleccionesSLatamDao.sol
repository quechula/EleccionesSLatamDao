
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.1;

contract EleccionesSLatamDao {
		//Estructura para almacenar los datos de un  delegado, donde el codogo de propuesta asignado es unico
	struct Delegado {
		string nombre;  
		uint edad;  
		string nombrePropuesta;  
		string nacionalidad; 
		address delegadoAddress;  
		bool exists; 
		bool tienePropuesta; 
		uint codigoDePropuesta;  
		uint voteCount; 
		
	}

	address public admin; //Direccion del administrador del contrato
	mapping (address => bool) public votantes; // Maping para verificar si una direccion es votante
	mapping(address => bool) public votosEmitidos; // Maping para verificar si un votante ya emitio su voto
	mapping(address => bool) public yaVotaste;     // Maping para verificar si un votante ya votó
	mapping (address => Delegado) public delegados; // Maping para almacenar la información de los delegados
	address[] public listaDeDelegado; // Lista de direcciones de los delegados registrados
	bool public votacionAbierta; // Variable para verificar si la votación está abierta
	uint public finDelTiempo; // Marca de tiempo para el fin de la votaci
	address public ganador;  // Dirección del ganador de la votación
	    

	// Funcion para agregar delegado
	function anadirDelegado(string memory nombre, uint edad, string memory nombrePropuesta, string memory nacionalidad, address delegadoAddress, uint codigoDePropuesta) public soloAdmin {
	require(!delegados[delegadoAddress].exists, "Delegado ya registrado.");
	require(codigoDePropuesta == 1, "Codigo de propuesta no valido.");
	delegados[delegadoAddress] = Delegado(nombre, edad, nombrePropuesta, nacionalidad, delegadoAddress, true, true, codigoDePropuesta, 0);
	listaDeDelegado.push(delegadoAddress);
		
	}

	//Funcion para mostar la lista de delegados inscritos por nombre
    function mostrarListaDeDelegado() public view returns (string[] memory) {
        uint len = listaDeDelegado.length;
        string[] memory nombres = new string[](len);
        for (uint i = 0; i < len; i++) {
            nombres[i] = delegados[listaDeDelegado[i]].nombre;
        }
        return nombres;
    }

	//Funcion para registrar a los votantes
	function registrarVotante(address _direccionVotante) public soloAdmin {
	votantes[_direccionVotante] = true;
    }

		// Función para que un votante emita su voto por un delegado
		function votar(address delegadoAddress) public {
		require(votantes[msg.sender], "No estas autorizado para votar");
		require(delegados[delegadoAddress].exists, "El Delegado no esta registrado");
		require(!votosEmitidos[msg.sender], "Ya emitiste tu voto");
		require(!yaVotaste[msg.sender], "Ya ha votado.");
	    
		delegados[delegadoAddress].voteCount++; //esta función registra el voto del remitente por un delegado específico al incrementar su contador de votos y marcar al remitente como un votante que ha emitido su voto
		votosEmitidos[msg.sender] = true;
		 yaVotaste[msg.sender] = true;
	}

	// Funcion para finalizar la votacion
	function finDeVotacion() public soloAdmin {
		votacionAbierta = false;
		finDelTiempo = block.timestamp; // Esta variable devuelve una marca de tiempo, donde inicia (al deployar) y finaliza la votacion (al cerrar)
		uint moyorVoto = 0;
		// Se determina quién tiene la mayor cantidad de votos (ganador) actualizandose con cada voto recorriendo la lista de delegados
		for (uint i = 0; i < listaDeDelegado.length; i++) {
			if (delegados[listaDeDelegado[i]].voteCount > moyorVoto) {
				moyorVoto = delegados[listaDeDelegado[i]].voteCount;
				ganador = listaDeDelegado[i];		
			}
		}
	}

	// Constructor del contrato
	constructor() {
		admin = msg.sender;
		votacionAbierta = true;
	}
	// Modificador que permite solo al administrador realizar una acción
	modifier soloAdmin() {
		require(msg.sender == admin, "Esta accion solo la puede hacer el admin.");
		_;		
	}
	// Modificador que verifica si la votación ha finalizado
	modifier votacionFinalizada() {
		require(!votacionAbierta, "La votacion aun no ha finalizado.");
		_;		
	}
}