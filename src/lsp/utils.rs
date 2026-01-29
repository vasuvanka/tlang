// Utility functions for LSP position handling

use tower_lsp::lsp_types::Position;

/// Extract identifier at the given position in source text
pub fn extract_identifier_at_position(source: &str, position: Position) -> Option<String> {
    let lines: Vec<&str> = source.lines().collect();
    let line_idx = position.line as usize;
    
    if line_idx >= lines.len() {
        return None;
    }
    
    let line = lines[line_idx];
    let char_idx = position.character as usize;
    
    if char_idx >= line.len() {
        return None;
    }
    
    // Find the start of the identifier (alphanumeric or underscore)
    let mut start = char_idx;
    while start > 0 {
        let ch = line.chars().nth(start - 1)?;
        if ch.is_alphanumeric() || ch == '_' || ch == '@' || ch == '#' {
            start -= 1;
        } else {
            break;
        }
    }
    
    // Find the end of the identifier
    let mut end = char_idx;
    while end < line.len() {
        let ch = line.chars().nth(end)?;
        if ch.is_alphanumeric() || ch == '_' || ch == '@' || ch == '#' {
            end += 1;
        } else {
            break;
        }
    }
    
    if start < end {
        Some(line[start..end].to_string())
    } else {
        None
    }
}

/// Extract word at position (simpler, for hover/definition)
pub fn extract_word_at_position(source: &str, position: Position) -> Option<String> {
    let lines: Vec<&str> = source.lines().collect();
    let line_idx = position.line as usize;
    
    if line_idx >= lines.len() {
        return None;
    }
    
    let line = lines[line_idx];
    let char_idx = position.character as usize;
    
    if char_idx >= line.len() {
        return None;
    }
    
    // Find word boundaries (alphanumeric, underscore, @, #)
    let mut start = char_idx;
    while start > 0 {
        let ch = line.chars().nth(start - 1)?;
        if ch.is_alphanumeric() || ch == '_' || ch == '@' || ch == '#' {
            start -= 1;
        } else {
            break;
        }
    }
    
    let mut end = char_idx;
    while end < line.len() {
        let ch = line.chars().nth(end)?;
        if ch.is_alphanumeric() || ch == '_' || ch == '@' || ch == '#' {
            end += 1;
        } else {
            break;
        }
    }
    
    if start < end {
        Some(line[start..end].to_string())
    } else {
        None
    }
}
