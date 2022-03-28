
function ProgrammeTest()
ConfigurerProjet;


client1 = Client('charles','barette','123456789');
Jocelyn = Client('Jocelyn','Dubuc','827891898');
comptePatate1 = Compte(1000,1000);
comptePouletBeurre1 = Compte(1000,1000);

celideJocelyn = Compte(2000,2000);

dejardounes = Banque('dejardounes','4');
dejardounes.AjouterClient(Jocelyn);
dejardounes.AjouterCompte(celideJocelyn,Jocelyn);


fprintf('nom du client: %s',dejardounes.ObtenirCompteParNumAssSociale('827891898').getNom());

end