
function ProgrammeTest()
ConfigurerProjet;


client1 = Client('charles','barette','123456789');

comptePatate1 = Compte('epargnes1',client1);
client1.ajouterCompte(comptePatate1);


fprintf('nom du compte: %s',client1.ObtenirCompte(1));

end