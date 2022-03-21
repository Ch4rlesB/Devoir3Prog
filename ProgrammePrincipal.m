function ProgrammePrincipal()
    %% Général
    % Configurer le projet (constante, etc.)
    ConfigurerProjet

    %% Main

    plateforme = Plateforme();
    plateforme.GenererRapport('RapportAvant')
    plateforme.AnalyserJournalTransactions('Transactions.txt');
    plateforme.GenererRapport('RapportApres')

end