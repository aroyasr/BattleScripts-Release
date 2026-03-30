#!/usr/bin/env python3
# file_validator.py
# This module validates a python file based on specific criteria. 
# Criteria:
# 1. The file must contain the function definition "def main(thismoney, theirmoney, currentturn, thisrecentturn, theirrecentturn):"
# 2. The file must contain a return statement that returns either "STEAL" or "SUPPORT".
# 3. The file must not contain any syntax errors.
# 4. The file must not contain any prohibited imports (e.g., os, sys).
# 5. The filename must end with .py extension.


# This file was heavily vibecoded thank you copilot!

import sys
import ast
import re
from pathlib import Path

# Prohibited imports that students should not use
PROHIBITED_IMPORTS = {'os', 'sys', 'subprocess', 'importlib', 'eval', 'exec', '__import__'}

def validate_file(filepath):
    """
    Validate a Python script against the criteria.
    
    Args:
        filepath: Path to the Python file to validate
        
    Returns:
        dict: {
            'valid': bool,
            'name': str (script name if valid),
            'errors': list (error messages)
        }
    """
    errors = []
    path = Path(filepath)
    
    # Check 5: Filename must end with .py
    if not path.suffix == '.py':
        errors.append(f"ERROR: File must have .py extension, got '{path.suffix}'")
        return {'valid': False, 'name': None, 'errors': errors}
    
    # Check if file exists
    if not path.exists():
        errors.append(f"ERROR: File not found: {filepath}")
        return {'valid': False, 'name': None, 'errors': errors}
    
    try:
        with open(filepath, 'r') as f:
            code = f.read()
    except Exception as e:
        errors.append(f"ERROR: Cannot read file: {str(e)}")
        return {'valid': False, 'name': None, 'errors': errors}
    
    # Check 3: No syntax errors
    try:
        ast.parse(code)
    except SyntaxError as e:
        errors.append(f"ERROR: Syntax error at line {e.lineno}: {e.msg}")
        return {'valid': False, 'name': None, 'errors': errors}
    
    # Check 4: No prohibited imports
    try:
        tree = ast.parse(code)
        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                for alias in node.names:
                    module_name = alias.name.split('.')[0]
                    if module_name in PROHIBITED_IMPORTS:
                        errors.append(f"ERROR: Prohibited import '{module_name}' found at line {node.lineno}")
            elif isinstance(node, ast.ImportFrom):
                module_name = node.module
                if module_name and module_name.split('.')[0] in PROHIBITED_IMPORTS:
                    errors.append(f"ERROR: Prohibited import '{module_name}' found at line {node.lineno}")
    except Exception as e:
        errors.append(f"ERROR: Failed to check imports: {str(e)}")
    
    # Check 1: Must contain main function with correct signature
    main_found = False
    try:
        tree = ast.parse(code)
        for node in ast.walk(tree):
            if isinstance(node, ast.FunctionDef) and node.name == 'main':
                # Check parameters
                params = [arg.arg for arg in node.args.args]
                expected_params = ['thismoney', 'theirmoney', 'currentturn', 'thisrecentturn', 'theirrecentturn']
                if params == expected_params:
                    main_found = True
                else:
                    errors.append(f"ERROR: main() has wrong parameters. Expected {expected_params}, got {params}")
                break
    except Exception as e:
        errors.append(f"ERROR: Failed to check main function: {str(e)}")
    
    if not main_found and not any('main()' in err for err in errors):
        errors.append("ERROR: Function 'def main(thismoney, theirmoney, currentturn, thisrecentturn, theirrecentturn):' not found")
    
    # If we have errors, return invalid
    if errors:
        return {'valid': False, 'name': None, 'errors': errors}
    
    # All checks passed
    return {'valid': True, 'name': path.stem, 'errors': []}


def main():
    """Entry point for Godot GDScript calls."""
    if len(sys.argv) < 2:
        print("ERROR: No file path provided")
        sys.exit(1)
    
    filepath = sys.argv[1]
    result = validate_file(filepath)
    
    if result['valid']:
        # Return the script name on success
        print(result['name'])
    else:
        # Return error messages on failure
        for error in result['errors']:
            print(error)
        sys.exit(1)


if __name__ == '__main__':
    main()