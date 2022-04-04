
function ProgrammeTest()
ConfigurerProjet;

format long g;
client1 = Client('charles','barette','123456789');
Jocelyn = Client('Jocelyn','Dubuc','827891898');
comptePatate1 = Compte(1000,1000);
comptePouletBeurre1 = Compte(1000,1000);

celideJocelyn = Compte(2000,2000);

dejardounes = Banque('dejardounes','4');
dejardounes.AjouterClient(Jocelyn);
dejardounes.AjouterCompte(celideJocelyn,Jocelyn);

plateforme = Plateforme();
plateforme.GenererRapport('RapportAvant');
%plateforme.AnalyserJournalTransactions('Transactions.txt');
%plateforme.GenererRapport('RapportApres');

end