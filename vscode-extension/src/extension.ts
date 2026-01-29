import * as vscode from 'vscode';
import {
    LanguageClient,
    LanguageClientOptions,
    ServerOptions,
    TransportKind
} from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: vscode.ExtensionContext) {
    // Get configuration
    const config = vscode.workspace.getConfiguration('tlang');
    const enableLanguageServer = config.get<boolean>('enableLanguageServer', true);
    const languageServerPath = config.get<string>('languageServerPath', 'tlang-lsp');

    if (!enableLanguageServer) {
        vscode.window.showInformationMessage('Tlang Language Server is disabled in settings.');
        return;
    }

    // Server options
    const serverOptions: ServerOptions = {
        run: {
            command: languageServerPath,
            transport: TransportKind.stdio,
            args: []
        },
        debug: {
            command: languageServerPath,
            transport: TransportKind.stdio,
            args: []
        }
    };

    // Client options
    const clientOptions: LanguageClientOptions = {
        // Register the server for tlang documents
        documentSelector: [{ scheme: 'file', language: 'tlang' }],
        synchronize: {
            // Notify the server about file changes to files contained in the workspace
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.tl')
        }
    };

    // Create the language client and start the client.
    client = new LanguageClient(
        'tlangLanguageServer',
        'Tlang Language Server',
        serverOptions,
        clientOptions
    );

    // Start the client. This will also launch the server
    client.start();

    // Register commands
    const restartCommand = vscode.commands.registerCommand('tlang.restartLanguageServer', async () => {
        await client.stop();
        client.start();
        vscode.window.showInformationMessage('Tlang Language Server restarted.');
    });

    context.subscriptions.push(restartCommand);
}

export function deactivate(): Thenable<void> | undefined {
    if (!client) {
        return undefined;
    }
    return client.stop();
}
