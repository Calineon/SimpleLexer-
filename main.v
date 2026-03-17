
module main
enum TokenType {
    number
    plus
    minus
    star
    slash
    lparen
    rparen
    ident
    eof
    illegal
}
struct Token {
    typ     TokenType
    literal string
}
struct Lexer {
mut:
    input   string
    pos     int
    ch      u8
}

fn new_lexer(input string) Lexer {
    mut l := Lexer{
        input: input
        pos:   0
        ch:    0
    }
    l.read_char()
    return l
}

fn (mut l Lexer) read_char() {
    if l.pos >= l.input.len {
        l.ch = 0
    } else {
        l.ch = l.input[l.pos]
    }
    l.pos++
}

fn (mut l Lexer) skip_whitespace() {
    for l.ch == ` ` || l.ch == `\t` || l.ch == `\n` || l.ch == `\r` {
        l.read_char()
    }
}

fn (mut l Lexer) read_number() string {
    mut result := ''
    for l.ch >= `0` && l.ch <= `9` {
        result += l.ch.ascii_str()
        l.read_char()
    }
    return result
}

fn (mut l Lexer) read_ident() string {
    mut result := ''
    for (l.ch >= `a` && l.ch <= `z`) || (l.ch >= `A` && l.ch <= `Z`) || l.ch == `_` {
        result += l.ch.ascii_str()
        l.read_char()
    }
    return result
}

fn (mut l Lexer) next_token() Token {
    l.skip_whitespace()

    tok := match l.ch {
        `+` { Token{ typ: .plus,   literal: '+' } }
        `-` { Token{ typ: .minus,  literal: '-' } }
        `*` { Token{ typ: .star,   literal: '*' } }
        `/` { Token{ typ: .slash,  literal: '/' } }
        `(` { Token{ typ: .lparen, literal: '(' } }
        `)` { Token{ typ: .rparen, literal: ')' } }
        0   { Token{ typ: .eof,    literal: ''  } }
        else {
            if l.ch >= `0` && l.ch <= `9` {
                return Token{ typ: .number, literal: l.read_number() }
            } else if (l.ch >= `a` && l.ch <= `z`) || (l.ch >= `A` && l.ch <= `Z`) || l.ch == `_` {
                return Token{ typ: .ident, literal: l.read_ident() }
            } else {
                Token{ typ: .illegal, literal: l.ch.ascii_str() }
            }
        }
    }

    l.read_char()
    return tok
}

fn main() {
    input := 'x + 42 * (foo - 7)'
    mut lexer := new_lexer(input)

    println('Входная строка: "${input}"\n')
    println('Токены:')

    for {
        tok := lexer.next_token()
        println('  ${tok.typ:-10} | "${tok.literal}"')
        if tok.typ == .eof {
            break
        }
    }
}
