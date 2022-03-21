function ProgrammePrincipal()
    %% Général
    %salut je suis alek
    % Configurer le projet (constante, etc.)
    ConfigurerProjet

    %% Main

    plateforme = Plateforme();
    plateforme.GenererRapport('RapportAvant')
    plateforme.AnalyserJournalTransactions('Transactions.txt');
    plateforme.GenererRapport('RapportApres')

end