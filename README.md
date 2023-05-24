# EleccionesSLatamDao
Permite elegir al delegado de la Dao en el Sur de Latam (Practica Solidity)

# SMART CONTRACT VOTACIONES PROYECTO FINAL
- Desarrollar un contrato inteligente que permita generar y administrar votaciones
- Permitiendo el registro de candidatos
- El dueño del contrato es el unico que puede dar derecho a voto a los votantes
- Una vez finalizada la votacion se debe poder ver al ganador

### Registrar a los votantes 
`	function registrarVotante(address _direccionVotante) public soloAdmin {
	votantes[_direccionVotante] = true;
    }
 `
    
### Finalizacion de la votacion

`	function finDeVotacion() public soloAdmin {
		votacionAbierta = false;
		finDelTiempo = block.timestamp;
		uint moyorVoto = 0;
		}
  `
    
### Modificador para acciones del administrador
`	modifier soloAdmin() {
		require(msg.sender == admin, "Esta accion solo la puede hacer el admin.");
		_;		
	}
`
