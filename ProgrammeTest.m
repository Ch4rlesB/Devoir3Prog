
function ProgrammeTest()
ConfigurerProjet();


client = Client();
compte = Compte('patate',client);

fprintf(compte.getIdentifiant()+'nom');

end