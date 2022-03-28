
function ProgrammeTest()
ConfigurerProjet;


client1 = Client('charles','barette','123456789');

comptePatate1 = Compte('epargnes1',client1);
comptePouletBeurre1 = Compte('celi1',client1);
client1.AjouterCompte(comptePouletBeurre1);
client1.AjouterCompte(comptePatate1);

compteAVerifier=client1.ObtenirCompte(1);

fprintf('nom du compte: %s',compteAVerifier.getIdentifiant());

end