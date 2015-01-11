package haxe.languageservices;

import haxe.languageservices.util.Vfs;
import haxe.languageservices.parser.TypeContext;
import haxe.languageservices.parser.Completion.CompletionEntry;
import haxe.languageservices.parser.Completion.CompletionList;
import haxe.languageservices.parser.Completion.CCompletion;
import haxe.languageservices.parser.Errors.ErrorContext;
import haxe.languageservices.parser.Parser;

class HaxeLanguageServices {
    private var vfs:Vfs;
    private var typeContext = new TypeContext();
    private var parsers = new Map<String, Parser>();
    public var classPaths = ["."];

    public function new(vfs:Vfs) {
        this.vfs = vfs;
    }
    
    public function updateHaxeScriptFile(path:String):Void {
        var parser = parsers[path] = new Parser(typeContext);
        var fileContent = vfs.readString(path);
        parser.setInputString(fileContent);
        var expr = parser.parseExpressions();
    }

    public function updateHaxeFile(path:String):Void {
        var parser = parsers[path] = new Parser(typeContext);
        var fileContent = vfs.readString(path);
        parser.setInputString(fileContent);
        var expr = parser.parseHaxeFile();
    }

    public function getCompletionAt(path:String, offset:Int):CompletionList {
        var parser:Parser = parsers[path];
        if (parser == null) throw 'Can\'t find parser for file $path';
        return parser.completionsAt(offset);
    }
    
    public function getCallInfoAt(path:String, offset:Int):CCompletion {
        var parser:Parser = parsers[path];
        return parser.callCompletionAt(offset);
    }

    public function getErrors(path:String):ErrorContext {
        var parser:Parser = parsers[path];
        return parser.errors;
    }
}